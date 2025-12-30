// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IngredientPhoto _$IngredientPhotoFromJson(Map<String, dynamic> json) =>
    _IngredientPhoto(
      id: json['id'] as String,
      path: json['path'] as String,
      source: $enumDecode(_$IngredientPhotoSourceEnumMap, json['source']),
      displayOrder: (json['displayOrder'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IngredientPhotoToJson(_IngredientPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'source': _$IngredientPhotoSourceEnumMap[instance.source]!,
      'displayOrder': instance.displayOrder,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$IngredientPhotoSourceEnumMap = {
  IngredientPhotoSource.camera: 'camera',
  IngredientPhotoSource.gallery: 'gallery',
};
