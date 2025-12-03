import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';

class _FlakyRecipeRepo implements RecipeRepository {
  _FlakyRecipeRepo(this._store);

  bool shouldThrow = true;
  final List<Recipe> _store;

  @override
  Future<void> deleteRecipe(String id) async {
    _store.removeWhere((r) => r.id == id);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    if (shouldThrow) {
      throw RecipeStorageException('Corrupted store');
    }
    return List.unmodifiable(_store);
  }

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async {
    shouldThrow = false;
    return getMyRecipes();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    _store.removeWhere((r) => r.id == recipe.id);
    _store.add(recipe);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await saveRecipe(recipe);
  }
}

Recipe _makeRecipe() => Recipe(
      id: 'r-recovery',
      name: 'Recovery Recipe',
      description: 'Recovered data',
      cookingTimeMinutes: 5,
      difficulty: RecipeDifficulty.easy,
      ingredients: [Ingredient(id: 'i1', name: 'Item', quantity: '1')],
      steps: const ['Step'],
      nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
      mealType: MealType.dinner,
      isUserCreated: true,
    );

void main() {
  testWidgets('shows recovery UI and heals after repair', (tester) async {
    final repo = _FlakyRecipeRepo([_makeRecipe()]);

    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    final state = container.read(recipeControllerProvider);
    expect(state.hasError, isTrue);

    repo.shouldThrow = false;
    await container.read(recipeControllerProvider.notifier).recoverStorage();
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final recovered = container.read(recipeControllerProvider).value ?? [];
    expect(recovered.map((r) => r.name), contains('Recovery Recipe'));
  });
}
