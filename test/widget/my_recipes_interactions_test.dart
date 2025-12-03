import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';

class _InMemoryRepo implements RecipeRepository {
  final List<Recipe> _store;
  _InMemoryRepo(this._store);

  @override
  Future<void> deleteRecipe(String id) async {
    _store.removeWhere((r) => r.id == id);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async => List.unmodifiable(_store);

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    _store.removeWhere((r) => r.id == recipe.id);
    _store.add(recipe);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async => saveRecipe(recipe);

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async => getMyRecipes();
}

Recipe _recipe(String id, String name) => Recipe(
      id: id,
      name: name,
      description: 'Desc',
      cookingTimeMinutes: 10,
      difficulty: RecipeDifficulty.easy,
      ingredients: [const Ingredient(id: 'i1', name: 'Item', quantity: '1')],
      steps: const ['Step'],
      nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
      mealType: MealType.dinner,
      isUserCreated: true,
    );

void main() {
  testWidgets('Swipe delete with undo restores recipe', (tester) async {
    final repo = _InMemoryRepo([_recipe('r1', 'Swipe Me')]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Swipe Me'), findsOneWidget);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Swipe Me'), findsNothing);
    expect(find.textContaining('deleted'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Swipe Me'), findsOneWidget);
  });
}
