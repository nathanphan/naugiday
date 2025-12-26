import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/repositories/ai_recipe_service.dart';
import 'package:naugiday/data/datasources/fake_ai_recipe_service.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';
import 'package:naugiday/presentation/screens/recipe_suggestions_screen.dart';

class _InstantAiService implements AiRecipeService {
  const _InstantAiService();
  @override
  Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestRecipesFromImages({required List<String> imagePaths, required MealType mealType}) async {
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
  setUp(() => DebugToggles.reset());

  testWidgets('Suggestions debug empty mode shows empty state', (tester) async {
    DebugToggles.suggestionsMode = SuggestionsDebugMode.empty;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiRecipeServiceProvider.overrideWith((ref) => const _InstantAiService()),
        ],
        child: const MaterialApp(
          home: RecipeSuggestionsScreen(
            imagePaths: [],
            labels: [],
            mealType: MealType.dinner,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('No recipes found'), findsOneWidget);
    DebugToggles.reset();
  });

  testWidgets('Storage debug error mode shows repair card', (tester) async {
    DebugToggles.storageMode = StorageDebugMode.error;
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(home: MyRecipesScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('We hit a storage issue.'), findsOneWidget);
    DebugToggles.reset();
  });
}
