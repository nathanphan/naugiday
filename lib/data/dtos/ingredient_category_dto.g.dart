// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientCategoryDto _$IngredientCategoryDtoFromJson(
  Map<String, dynamic> json,
) => IngredientCategoryDto(
  id: json['id'] as String,
  name: json['name'] as String,
  isCustom: json['isCustom'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$IngredientCategoryDtoToJson(
  IngredientCategoryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isCustom': instance.isCustom,
  'createdAt': instance.createdAt.toIso8601String(),
};
