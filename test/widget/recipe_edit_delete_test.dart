import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';

class _MemoryRepo implements RecipeRepository {
  final Map<String, Recipe> _store = {};
  @override
  Future<void> deleteRecipe(String id) async => _store.remove(id);
  @override
  Future<List<Recipe>> getMyRecipes() async => _store.values.toList();
  @override
  Future<void> saveRecipe(Recipe recipe) async => _store[recipe.id] = recipe;
  @override
  Future<void> updateRecipe(Recipe recipe) async => _store[recipe.id] = recipe;

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async => getMyRecipes();
}

Recipe _recipe(String id, String name) => Recipe(
      id: id,
      name: name,
      description: 'Desc',
      cookingTimeMinutes: 10,
      difficulty: RecipeDifficulty.easy,
      ingredients: [Ingredient(id: 'i1', name: 'Item', quantity: '1')],
      steps: const ['Do it'],
      nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
      mealType: MealType.dinner,
      isUserCreated: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

void main() {
  testWidgets('edit and delete persist across rebuild', (tester) async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    // Seed a recipe and open list
    await container.read(recipeControllerProvider.notifier).addRecipe(_recipe('r1', 'Old'));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Old'), findsOneWidget);

    // Update via controller (simulating edit flow)
    await container
        .read(recipeControllerProvider.notifier)
        .updateRecipe(_recipe('r1', 'New Title'));
    await tester.pumpAndSettle();
    expect(find.text('New Title'), findsOneWidget);

    // Simulate restart by rebuilding with same repo/container
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('New Title'), findsOneWidget);

    // Delete via controller and verify gone
    await container.read(recipeControllerProvider.notifier).deleteRecipe('r1');
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('New Title'), findsNothing);
  });
}
