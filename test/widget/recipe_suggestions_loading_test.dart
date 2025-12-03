import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/repositories/ai_recipe_service.dart';
import 'package:naugiday/data/datasources/fake_ai_recipe_service.dart';
import 'package:naugiday/presentation/providers/suggestions_provider.dart';
import 'package:naugiday/presentation/screens/recipe_suggestions_screen.dart';

class _InstantAiService implements AiRecipeService {
  @override
  Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestRecipesFromImages({
    required List<String> imagePaths,
    required MealType mealType,
  }) async {
    return (
      detectedIngredients: const ['Stub'],
      recipes: [
        Recipe(
          id: 'r',
          name: 'Stub',
          description: 'Desc',
          cookingTimeMinutes: 1,
          difficulty: RecipeDifficulty.easy,
          ingredients: [const Ingredient(id: 'i', name: 'Item', quantity: '1')],
          steps: const ['Step'],
          nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
          mealType: mealType,
          isUserCreated: true,
        ),
      ],
    );
  }
}

void main() {
  testWidgets('Suggestions loading shows skeleton grid', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiRecipeServiceProvider.overrideWith((ref) => _InstantAiService()),
          // Keep provider pending by never completing the future (no timers involved).
          suggestionsProvider(
            imagePaths: const [],
            labels: const [],
            mealType: MealType.dinner,
          ).overrideWith(
            (ref) => Completer<({List<String> detectedIngredients, List<Recipe> recipes})>().future,
          ),
        ],
        child: const MaterialApp(
          home: RecipeSuggestionsScreen(imagePaths: [], labels: [], mealType: MealType.dinner),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
