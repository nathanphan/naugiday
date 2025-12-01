import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/presentation/providers/suggestions_provider.dart';

class RecipeSuggestionsScreen extends ConsumerWidget {
  final List<String> imagePaths;
  final MealType mealType;

  const RecipeSuggestionsScreen({
    super.key,
    required this.imagePaths,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(
      suggestionsProvider(imagePaths: imagePaths, mealType: mealType),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      body: suggestionsAsync.when(
        data: (data) {
          final detected = data.detectedIngredients;
          final recipes = data.recipes;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (detected.isNotEmpty) ...[
                Text(
                  'Detected: ${detected.join(", ")}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
              ],
              ...recipes.map((recipe) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text(
                        '${recipe.cookingTimeMinutes} min • ${recipe.difficulty.name}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.go('/recipe-detail', extra: {
                          'recipe': recipe,
                          'detected': detected,
                        });
                      },
                    ),
                  )),
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
