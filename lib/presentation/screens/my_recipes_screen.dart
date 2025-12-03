import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/core/constants/app_assets.dart';
import 'package:naugiday/presentation/widgets/skeletons.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';

class MyRecipesScreen extends ConsumerStatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  ConsumerState<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends ConsumerState<MyRecipesScreen> {
  final Set<String> _pinned = {};
  final Set<String> _favorites = {};

  @override
  Widget build(BuildContext context) {
    final baseAsync = ref.watch(recipeControllerProvider);
    final AsyncValue<List<Recipe>> recipesAsync = DebugToggles.storageMode == StorageDebugMode.error
        ? const AsyncError('Debug storage error', StackTrace.empty)
        : DebugToggles.storageMode == StorageDebugMode.empty
            ? const AsyncData(<Recipe>[])
            : baseAsync;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(recipeControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-recipe'),
        child: const Icon(Icons.add),
      ),
      body: recipesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.emptyState,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text('No recipes yet. Create one! (Works offline)'),
                ],
              ),
            );
          }
          return AnimatedSwitcher(
            duration: AppTheme.animFast,
            child: ListView.builder(
              key: ValueKey(recipes.length),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final pinned = _pinned.contains(recipe.id);
                final favorite = _favorites.contains(recipe.id);
                final notifier = ref.read(recipeControllerProvider.notifier);
                return Dismissible(
                  key: ValueKey('dismiss-${recipe.id}'),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete recipe?'),
                            content: Text('Remove "${recipe.name}" from My Recipes?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) {
                    notifier.deleteRecipe(recipe.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"${recipe.name}" deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => notifier.addRecipe(recipe),
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            color: favorite ? Colors.redAccent : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (favorite) {
                                _favorites.remove(recipe.id);
                              } else {
                                _favorites.add(recipe.id);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined),
                          onPressed: () {
                            setState(() {
                              if (pinned) {
                                _pinned.remove(recipe.id);
                              } else {
                                _pinned.add(recipe.id);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.go('/create-recipe', extra: {'recipe': recipe});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            notifier.deleteRecipe(recipe.id).then((_) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('"${recipe.name}" deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () => notifier.addRecipe(recipe),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.go(
                        '/recipe-detail',
                        extra: {
                          'recipe': recipe,
                          'detected': <String>[], // No detected ingredients for manual recipes
                        },
                      );
                    },
                    onLongPress: () {
                      setState(() {
                        if (pinned) {
                          _pinned.remove(recipe.id);
                        } else {
                          _pinned.add(recipe.id);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const SkeletonList(),
        error: (err, stack) {
          final fallback = recipesAsync.asData?.value;
          return Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.emptyState, height: 180),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'We hit a storage issue.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    _describeError(err),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Wrap(
                    spacing: AppTheme.spacingS,
                    runSpacing: AppTheme.spacingS,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => ref.read(recipeControllerProvider.notifier).refresh(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => ref.read(recipeControllerProvider.notifier).recoverStorage(),
                        icon: const Icon(Icons.shield),
                        label: const Text('Repair storage'),
                      ),
                    ],
                  ),
                  if (fallback != null && fallback.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'Your recipes are still available:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    ...fallback.map(
                      (recipe) => ListTile(
                        title: Text(recipe.name),
                        subtitle: Text(recipe.description),
                        onTap: () {
                          context.go(
                            '/recipe-detail',
                            extra: {
                              'recipe': recipe,
                              'detected': <String>[],
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _describeError(Object err) {
    if (err is RecipeStorageException) {
      return err.message;
    }
    if (err is Exception) {
      return err.toString();
    }
    return 'Please try again.';
  }
}
