import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/screens/recipe_detail_screen.dart';

Recipe _recipe() => Recipe(
      id: 'r-detail',
      name: 'Action Dish',
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
  testWidgets('Detail shows save/share CTA', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailScreen(recipe: _recipe(), detectedIngredients: const []),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Add missing items'), findsOneWidget);
  });
}
