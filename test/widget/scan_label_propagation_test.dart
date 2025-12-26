import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/datasources/fake_ai_recipe_service.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/ai_recipe_service.dart';
import 'package:naugiday/presentation/screens/recipe_suggestions_screen.dart';

class _StubAiService implements AiRecipeService {
  @override
  Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestRecipesFromImages({
    required List<String> imagePaths,
    required MealType mealType,
  }) async {
    return (
      detectedIngredients: const ['Stub'],
      recipes: [
        Recipe(
          id: 'r1',
          name: 'Stubbed Recipe',
          description: 'Desc',
          cookingTimeMinutes: 10,
          difficulty: RecipeDifficulty.easy,
          ingredients: [const Ingredient(id: 'i1', name: 'Item', quantity: '1')],
          steps: const ['Do it'],
          nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
          mealType: mealType,
          isUserCreated: true,
        ),
      ],
    );
  }
}

void main() {
  testWidgets('Edited labels appear in detected ingredients banner', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiRecipeServiceProvider.overrideWith((ref) => _StubAiService()),
        ],
        child: const MaterialApp(
          home: RecipeSuggestionsScreen(
            imagePaths: [],
            labels: ['Edited Label'],
            mealType: MealType.dinner,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('Edited Label'), findsOneWidget);
  });
}
