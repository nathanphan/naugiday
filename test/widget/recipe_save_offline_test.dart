import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';
import 'package:naugiday/presentation/screens/recipe_detail_screen.dart';

class _MemoryRecipeRepo implements RecipeRepository {
  final Map<String, Recipe> _store = {};

  @override
  Future<void> deleteRecipe(String id) async {
    _store.remove(id);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    return _store.values.toList();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    _store[recipe.id] = recipe;
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    _store[recipe.id] = recipe;
  }

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async {
    return getMyRecipes();
  }
}

void main() {
  testWidgets('save and reopen offline with back navigation control', (tester) async {
    final repo = _MemoryRecipeRepo();
    final recipe = Recipe(
      id: 'r1',
      name: 'Goi Cuon',
      description: 'Fresh spring rolls',
      cookingTimeMinutes: 20,
      difficulty: RecipeDifficulty.easy,
      ingredients: [Ingredient(id: 'i1', name: 'Shrimp', quantity: '8 pcs')],
      steps: const ['Prep fillings', 'Roll rice paper'],
      nutrition: const NutritionInfo(calories: 250, protein: 15, carbs: 30, fat: 8),
      mealType: MealType.lunch,
      isUserCreated: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

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
    await tester.pumpAndSettle();

    // Empty state initially
    expect(find.textContaining('No recipes'), findsOneWidget);

    // Add recipe via controller
    await container.read(recipeControllerProvider.notifier).addRecipe(recipe);
    await tester.pumpAndSettle();

    // List shows saved recipe
    expect(find.text('Goi Cuon'), findsOneWidget);

    // Detail screen shows back control
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailScreen(recipe: recipe, detectedIngredients: const []),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Back to home'), findsOneWidget);
  });
}
