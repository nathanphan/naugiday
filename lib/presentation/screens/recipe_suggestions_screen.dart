import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/presentation/providers/suggestions_provider.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/core/constants/app_assets.dart';
import 'package:naugiday/presentation/widgets/recipe_card.dart';
import 'package:naugiday/presentation/widgets/skeletons.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';

class RecipeSuggestionsScreen extends ConsumerStatefulWidget {
  final List<String> imagePaths;
  final List<String> labels;
  final MealType mealType;

  const RecipeSuggestionsScreen({
    super.key,
    required this.imagePaths,
    required this.labels,
    required this.mealType,
  });

  @override
  ConsumerState<RecipeSuggestionsScreen> createState() =>
      _RecipeSuggestionsScreenState();
}

class _RecipeSuggestionsScreenState
    extends ConsumerState<RecipeSuggestionsScreen> {
  String _searchQuery = '';
  final Set<String> _selectedFilters = {};
  bool _errorSnackbarShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(telemetryControllerProvider.notifier).recordCta('generate_recipe');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flagsAsync = ref.watch(featureFlagControllerProvider);
    if (flagsAsync.value != null && !flagsAsync.value!.aiEnabled) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe Suggestions'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.emptyState, height: 180),
              const SizedBox(height: AppTheme.spacingM),
              Text(
                'AI suggestions are currently unavailable.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingS),
              const Text(
                'Try again later or rescan ingredients.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingM),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Rescan'),
              ),
            ],
          ),
        ),
      );
    }
    final suggestionsAsync = ref.watch(
      suggestionsProvider(
        imagePaths: widget.imagePaths,
        labels: widget.labels,
        mealType: widget.mealType,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Suggestions'),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: AppTheme.animFast,
        child: suggestionsAsync.when(
          data: (data) {
          final detected = data.detectedIngredients;
          var recipes = data.recipes;

          // Apply search filter
          if (_searchQuery.isNotEmpty) {
            recipes = recipes.where((recipe) {
              return recipe.name.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();
          }

          // Apply difficulty filter
          if (_selectedFilters.isNotEmpty) {
            recipes = recipes.where((recipe) {
              return _selectedFilters.contains(recipe.difficulty.name);
            }).toList();
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(
                  hintText: 'Search recipes...',
                  leading: const Icon(Icons.search),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // Detected Ingredients
              if (detected.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detected Ingredients',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detected.join(', '),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),

              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Easy'),
                        selected: _selectedFilters.contains('easy'),
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: _selectedFilters.contains('easy')
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                        backgroundColor: theme.colorScheme.surface,
                        selectedColor: theme.colorScheme.primary,
                        checkmarkColor: _selectedFilters.contains('easy')
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        showCheckmark: false,
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFilters.add('easy');
                            } else {
                              _selectedFilters.remove('easy');
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Medium'),
                        selected: _selectedFilters.contains('medium'),
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: _selectedFilters.contains('medium')
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                        backgroundColor: theme.colorScheme.surface,
                        selectedColor: theme.colorScheme.primary,
                        checkmarkColor: _selectedFilters.contains('medium')
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        showCheckmark: false,
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFilters.add('medium');
                            } else {
                              _selectedFilters.remove('medium');
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Hard'),
                        selected: _selectedFilters.contains('hard'),
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: _selectedFilters.contains('hard')
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                        backgroundColor: theme.colorScheme.surface,
                        selectedColor: theme.colorScheme.primary,
                        checkmarkColor: _selectedFilters.contains('hard')
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        showCheckmark: false,
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFilters.add('hard');
                            } else {
                              _selectedFilters.remove('hard');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Recipe Grid
              Expanded(
                child: recipes.isEmpty
                    ? _buildEmptyState(context)
                    : AnimatedSwitcher(
                        duration: AppTheme.animFast,
                        child: GridView.builder(
                          key: ValueKey(recipes.length),
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return RecipeCard(
                              recipe: recipe,
                              onTap: () {
                                context.go(
                                  '/recipe-detail',
                                  extra: {'recipe': recipe, 'detected': detected},
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
          },
          loading: () => const SkeletonCardGrid(),
          error: (err, stack) {
            if (!_errorSnackbarShown) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not load suggestions: $err')),
                );
              });
              _errorSnackbarShown = true;
            }
            return _buildErrorState(context, err);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.emptyState, height: 180),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'No recipes found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          const Text('Try clearing filters or rescanning ingredients.'),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedFilters.clear();
                    _searchQuery = '';
                  });
                },
                child: const Text('Clear filters'),
              ),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Rescan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object err) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.emptyState, height: 180),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'We ran into an issue.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text('$err'),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            children: [
              OutlinedButton(
                onPressed: () => setState(() {}),
                child: const Text('Retry'),
              ),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Rescan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
