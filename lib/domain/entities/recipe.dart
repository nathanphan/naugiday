import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naugiday/domain/entities/cooking_step.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

enum RecipeDifficulty { easy, medium, hard }

@freezed
abstract class Recipe with _$Recipe {
  const Recipe._();

  const factory Recipe({
    required String id,
    required String name,
    required String description,
    required int cookingTimeMinutes,
    required RecipeDifficulty difficulty,
    required List<Ingredient> ingredients,
    @Default(<String>[]) List<String> steps,
    @Default(<CookingStep>[]) List<CookingStep> cookingSteps,
    @Default(<RecipeImage>[]) List<RecipeImage> images,
    required NutritionInfo nutrition,
    required MealType mealType,
    @Default(false) bool isUserCreated,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}
