import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/data/dtos/ingredient_dto.dart';
import 'package:naugiday/data/dtos/nutrition_info_dto.dart';

part 'recipe_dto.g.dart';

@JsonSerializable()
class RecipeDto {
  final String id;
  final String name;
  final String description;
  final int cookingTimeMinutes;
  final int difficultyIndex;
  final List<IngredientDto> ingredients;
  final List<String> steps;
  final NutritionInfoDto nutrition;
  final int mealTypeIndex;
  final bool isUserCreated;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RecipeDto({
    required this.id,
    required this.name,
    required this.description,
    required this.cookingTimeMinutes,
    required this.difficultyIndex,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
    required this.mealTypeIndex,
    required this.isUserCreated,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RecipeDto.fromDomain(Recipe recipe) {
    return RecipeDto(
      id: recipe.id,
      name: recipe.name,
      description: recipe.description,
      cookingTimeMinutes: recipe.cookingTimeMinutes,
      difficultyIndex: recipe.difficulty.index,
      ingredients: recipe.ingredients.map(IngredientDto.fromDomain).toList(),
      steps: recipe.steps,
      nutrition: NutritionInfoDto.fromDomain(recipe.nutrition),
      mealTypeIndex: recipe.mealType.index,
      isUserCreated: recipe.isUserCreated,
      imageUrl: recipe.imageUrl,
      createdAt: recipe.createdAt,
      updatedAt: recipe.updatedAt,
    );
  }

  Recipe toDomain() {
    return Recipe(
      id: id,
      name: name,
      description: description,
      cookingTimeMinutes: cookingTimeMinutes,
      difficulty: RecipeDifficulty.values[difficultyIndex],
      ingredients: ingredients.map((e) => e.toDomain()).toList(),
      steps: steps,
      nutrition: nutrition.toDomain(),
      mealType: MealType.values[mealTypeIndex],
      isUserCreated: isUserCreated,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory RecipeDto.fromJson(Map<String, dynamic> json) =>
      _$RecipeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeDtoToJson(this);
}
