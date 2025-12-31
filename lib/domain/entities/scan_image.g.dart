// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanImage _$ScanImageFromJson(Map<String, dynamic> json) => _ScanImage(
  id: json['id'] as String,
  source: $enumDecode(_$ScanImageSourceEnumMap, json['source']),
  path: json['path'] as String,
  thumbnailPath: json['thumbnailPath'] as String?,
  sizeBytes: (json['sizeBytes'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: $enumDecode(_$ScanImageStatusEnumMap, json['status']),
  failureReason: json['failureReason'] as String?,
);

Map<String, dynamic> _$ScanImageToJson(_ScanImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': _$ScanImageSourceEnumMap[instance.source]!,
      'path': instance.path,
      'thumbnailPath': instance.thumbnailPath,
      'sizeBytes': instance.sizeBytes,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ScanImageStatusEnumMap[instance.status]!,
      'failureReason': instance.failureReason,
    };

const _$ScanImageSourceEnumMap = {
  ScanImageSource.camera: 'camera',
  ScanImageSource.gallery: 'gallery',
};

const _$ScanImageStatusEnumMap = {
  ScanImageStatus.queued: 'queued',
  ScanImageStatus.processing: 'processing',
  ScanImageStatus.processed: 'processed',
  ScanImageStatus.failed: 'failed',
};
