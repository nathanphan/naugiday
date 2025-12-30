// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_photo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientPhotoDto _$IngredientPhotoDtoFromJson(Map<String, dynamic> json) =>
    IngredientPhotoDto(
      id: json['id'] as String,
      path: json['path'] as String,
      source: json['source'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IngredientPhotoDtoToJson(IngredientPhotoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'source': instance.source,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };
