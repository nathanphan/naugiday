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
  final bool throwError;
  const _InstantAiService({this.throwError = false});

  @override
  Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestRecipesFromImages({
    required List<String> imagePaths,
    required MealType mealType,
  }) async {
    if (throwError) throw Exception('boom');
    return (
      detectedIngredients: const <String>[],
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
  testWidgets('Suggestions empty state shows CTAs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiRecipeServiceProvider.overrideWith((ref) => const _InstantAiService()),
          suggestionsProvider(imagePaths: const [], labels: const [], mealType: MealType.dinner)
              .overrideWith((ref) async => (detectedIngredients: <String>[], recipes: <Recipe>[])),
        ],
        child: const MaterialApp(
          home: RecipeSuggestionsScreen(imagePaths: [], labels: [], mealType: MealType.dinner),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No recipes found'), findsOneWidget);
    expect(find.text('Clear filters'), findsOneWidget);
    expect(find.text('Rescan'), findsOneWidget);
  });

  testWidgets('Suggestions error state shows retry/rescan', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiRecipeServiceProvider.overrideWith((ref) => const _InstantAiService(throwError: true)),
          suggestionsProvider(imagePaths: const [], labels: const [], mealType: MealType.dinner)
              .overrideWith((ref) => Future.error('boom')),
        ],
        child: const MaterialApp(
          home: RecipeSuggestionsScreen(imagePaths: [], labels: [], mealType: MealType.dinner),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('We ran into an issue.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Rescan'), findsOneWidget);
  });
}
