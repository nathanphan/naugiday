import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

abstract class AiRecipeService {
  Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestRecipesFromImages({
    required List<String> imagePaths,
    required MealType mealType,
  });
}
