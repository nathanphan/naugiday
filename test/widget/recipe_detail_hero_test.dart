import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/screens/recipe_detail_screen.dart';

Recipe _makeRecipe() => Recipe(
      id: 'r-hero',
      name: 'Hero Dish',
      description: 'Tasty hero',
      cookingTimeMinutes: 10,
      difficulty: RecipeDifficulty.easy,
      ingredients: [const Ingredient(id: 'i1', name: 'Item', quantity: '1')],
      steps: const ['Step one'],
      nutrition: const NutritionInfo(calories: 10, protein: 1, carbs: 1, fat: 1),
      mealType: MealType.dinner,
      isUserCreated: true,
    );

void main() {
  testWidgets('Detail screen contains hero for recipe image', (tester) async {
    final recipe = _makeRecipe();
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailScreen(recipe: recipe, detectedIngredients: const []),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300)); // allow skeleton to settle

    final heroFinder = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == recipe.id,
    );
    expect(heroFinder, findsOneWidget);
  });
}
