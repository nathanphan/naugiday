import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/ai_recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:uuid/uuid.dart';

part 'fake_ai_recipe_service.g.dart';

@riverpod
AiRecipeService aiRecipeService(Ref ref) {
  final flagsAsync = ref.watch(featureFlagControllerProvider);
  final aiEnabled = flagsAsync.value?.aiEnabled ?? true;
  return FakeAiRecipeService(isEnabled: aiEnabled);
}

class FakeAiRecipeService implements AiRecipeService {
  FakeAiRecipeService({required this.isEnabled});

  final bool isEnabled;

  @override
  Future<({List<String> detectedIngredients, List<Recipe> recipes})>
  suggestRecipesFromImages({
    required List<String> imagePaths,
    required MealType mealType,
  }) async {
    if (!isEnabled) {
      throw StateError('AI suggestions disabled');
    }
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock detected ingredients
    final detected = ['Shrimp', 'Pork Belly', 'Fish Sauce', 'Green Onion'];

    // Mock recipes based on meal type (simplified for MVP)
    final recipes = _getMockRecipes(mealType);

    return (detectedIngredients: detected, recipes: recipes);
  }

  List<Recipe> _getMockRecipes(MealType mealType) {
    const uuid = Uuid();

    // Common ingredients
    final shrimp = const Ingredient(id: '1', name: 'Shrimp', quantity: '200g');
    final pork = const Ingredient(id: '2', name: 'Pork Belly', quantity: '150g');
    final fishSauce = const Ingredient(id: '3', name: 'Fish Sauce', quantity: '2 tbsp');
    final rice = const Ingredient(id: '4', name: 'Rice', quantity: '1 cup');
    final egg = const Ingredient(id: '5', name: 'Egg', quantity: '2 eggs');

    if (mealType == MealType.breakfast) {
      return [
        Recipe(
          id: uuid.v4(),
          name: 'Banh Mi Op La',
          description: 'Vietnamese sunny-side up eggs with baguette.',
          cookingTimeMinutes: 15,
          difficulty: RecipeDifficulty.easy,
          ingredients: [egg, pork, fishSauce],
          steps: [
            'Heat pan with oil.',
            'Crack eggs and fry until whites are set.',
            'Serve with baguette, soy sauce, and cucumber.',
          ],
          nutrition: const NutritionInfo(
            calories: 450,
            protein: 20,
            carbs: 40,
            fat: 22,
          ),
          mealType: MealType.breakfast,
        ),
      ];
    }

    // Default for Lunch/Dinner
    return [
      Recipe(
        id: uuid.v4(),
        name: 'Tom Rim Thit',
        description: 'Caramelized Shrimp and Pork Belly.',
        cookingTimeMinutes: 40,
        difficulty: RecipeDifficulty.medium,
        ingredients: [shrimp, pork, fishSauce, rice],
        steps: [
          'Marinate shrimp and pork with fish sauce and sugar.',
          'Caramelize sugar in a pot.',
          'Add meat and shrimp, simmer until sauce thickens.',
          'Serve with hot rice.',
        ],
        nutrition: const NutritionInfo(
          calories: 600,
          protein: 35,
          carbs: 50,
          fat: 25,
        ),
        mealType: mealType,
      ),
      Recipe(
        id: uuid.v4(),
        name: 'Canh Chua Tom',
        description: 'Sour Shrimp Soup.',
        cookingTimeMinutes: 30,
        difficulty: RecipeDifficulty.medium,
        ingredients: [shrimp, fishSauce],
        steps: [
          'Boil water, add tamarind.',
          'Add shrimp and vegetables (pineapple, tomato, okra).',
          'Season with fish sauce and sugar.',
          'Garnish with herbs.',
        ],
        nutrition: const NutritionInfo(
          calories: 200,
          protein: 15,
          carbs: 10,
          fat: 5,
        ),
        mealType: mealType,
      ),
    ];
  }
}
