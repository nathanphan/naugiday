import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/presentation/providers/my_recipes_provider.dart';

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(myRecipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-recipe'),
        child: const Icon(Icons.add),
      ),
      body: recipesAsync.when(
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes yet. Create one!'));
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(myRecipesProvider.notifier).deleteRecipe(recipe.id);
                  },
                ),
                onTap: () {
                  context.go('/recipe-detail', extra: {
                    'recipe': recipe,
                    'detected': <String>[], // No detected ingredients for manual recipes
                  });
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
