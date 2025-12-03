import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/core/constants/app_assets.dart';

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipeControllerProvider);

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
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        context.go('/create-recipe', extra: {'recipe': recipe});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(recipeControllerProvider.notifier)
                            .deleteRecipe(recipe.id);
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
              );
            },
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) => const _RecipeSkeleton(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: 4,
        ),
        error: (err, stack) {
          final fallback = recipesAsync.asData?.value;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber, size: 48, color: Colors.orange),
                  const SizedBox(height: 8),
                  Text(
                    'We hit a storage issue.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _describeError(err),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                    const SizedBox(height: 16),
                    Text(
                      'Your recipes are still available:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
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

class _RecipeSkeleton extends StatelessWidget {
  const _RecipeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
