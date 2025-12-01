import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

part 'recipe.freezed.dart';

enum RecipeDifficulty { easy, medium, hard }

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required String description,
    required int cookingTimeMinutes,
    required RecipeDifficulty difficulty,
    required List<Ingredient> ingredients,
    required List<String> steps,
    required NutritionInfo nutrition,
    required MealType mealType,
    @Default(false) bool isUserCreated,
    String? imageUrl,
  }) = _Recipe;
}
