// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeImage _$RecipeImageFromJson(Map<String, dynamic> json) => _RecipeImage(
  id: json['id'] as String,
  localPath: json['localPath'] as String,
  fileName: json['fileName'] as String,
  fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
  addedAt: json['addedAt'] == null
      ? null
      : DateTime.parse(json['addedAt'] as String),
);

Map<String, dynamic> _$RecipeImageToJson(_RecipeImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'localPath': instance.localPath,
      'fileName': instance.fileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'addedAt': instance.addedAt?.toIso8601String(),
    };
