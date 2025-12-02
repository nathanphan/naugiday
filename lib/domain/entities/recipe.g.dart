// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  cookingTimeMinutes: (json['cookingTimeMinutes'] as num).toInt(),
  difficulty: $enumDecode(_$RecipeDifficultyEnumMap, json['difficulty']),
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
  nutrition: NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>),
  mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
  isUserCreated: json['isUserCreated'] as bool? ?? false,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cookingTimeMinutes': instance.cookingTimeMinutes,
  'difficulty': _$RecipeDifficultyEnumMap[instance.difficulty]!,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
  'nutrition': instance.nutrition,
  'mealType': _$MealTypeEnumMap[instance.mealType]!,
  'isUserCreated': instance.isUserCreated,
  'imageUrl': instance.imageUrl,
};

const _$RecipeDifficultyEnumMap = {
  RecipeDifficulty.easy: 'easy',
  RecipeDifficulty.medium: 'medium',
  RecipeDifficulty.hard: 'hard',
};

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
};
