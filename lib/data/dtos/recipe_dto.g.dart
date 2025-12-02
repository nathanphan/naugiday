// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeDto _$RecipeDtoFromJson(Map<String, dynamic> json) => RecipeDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  cookingTimeMinutes: (json['cookingTimeMinutes'] as num).toInt(),
  difficultyIndex: (json['difficultyIndex'] as num).toInt(),
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => IngredientDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
  nutrition: NutritionInfoDto.fromJson(
    json['nutrition'] as Map<String, dynamic>,
  ),
  mealTypeIndex: (json['mealTypeIndex'] as num).toInt(),
  isUserCreated: json['isUserCreated'] as bool,
  imageUrl: json['imageUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecipeDtoToJson(RecipeDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cookingTimeMinutes': instance.cookingTimeMinutes,
  'difficultyIndex': instance.difficultyIndex,
  'ingredients': instance.ingredients,
  'steps': instance.steps,
  'nutrition': instance.nutrition,
  'mealTypeIndex': instance.mealTypeIndex,
  'isUserCreated': instance.isUserCreated,
  'imageUrl': instance.imageUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
