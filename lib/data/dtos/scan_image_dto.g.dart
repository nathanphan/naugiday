// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanImageDto _$ScanImageDtoFromJson(Map<String, dynamic> json) => ScanImageDto(
  id: json['id'] as String,
  source: json['source'] as String,
  path: json['path'] as String,
  thumbnailPath: json['thumbnailPath'] as String?,
  sizeBytes: (json['sizeBytes'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String,
  failureReason: json['failureReason'] as String?,
);

Map<String, dynamic> _$ScanImageDtoToJson(ScanImageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'path': instance.path,
      'thumbnailPath': instance.thumbnailPath,
      'sizeBytes': instance.sizeBytes,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'failureReason': instance.failureReason,
    };
