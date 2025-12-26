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
  steps:
      (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  cookingSteps:
      (json['cookingSteps'] as List<dynamic>?)
          ?.map((e) => CookingStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CookingStep>[],
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => RecipeImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecipeImage>[],
  nutrition: NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>),
  mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
  isUserCreated: json['isUserCreated'] as bool? ?? false,
  imageUrl: json['imageUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cookingTimeMinutes': instance.cookingTimeMinutes,
  'difficulty': _$RecipeDifficultyEnumMap[instance.difficulty]!,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
  'cookingSteps': instance.cookingSteps,
  'images': instance.images,
  'nutrition': instance.nutrition,
  'mealType': _$MealTypeEnumMap[instance.mealType]!,
  'isUserCreated': instance.isUserCreated,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
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
