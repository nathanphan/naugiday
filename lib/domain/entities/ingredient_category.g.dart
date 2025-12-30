// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IngredientCategory _$IngredientCategoryFromJson(Map<String, dynamic> json) =>
    _IngredientCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      isCustom: json['isCustom'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IngredientCategoryToJson(_IngredientCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isCustom': instance.isCustom,
      'createdAt': instance.createdAt.toIso8601String(),
    };
