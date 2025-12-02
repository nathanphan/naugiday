import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/suggestions_provider.dart';
import 'package:naugiday/presentation/widgets/recipe_card.dart';

class RecipeSuggestionsScreen extends ConsumerStatefulWidget {
  final List<String> imagePaths;
  final MealType mealType;

  const RecipeSuggestionsScreen({
    super.key,
    required this.imagePaths,
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

  @override
  Widget build(BuildContext context) {
    final suggestionsAsync = ref.watch(
      suggestionsProvider(
        imagePaths: widget.imagePaths,
        mealType: widget.mealType,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Suggestions'),
        centerTitle: true,
      ),
      body: suggestionsAsync.when(
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
                    ? const Center(child: Text('No recipes found'))
                    : GridView.builder(
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
            ],
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Analyzing ingredients...'),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
