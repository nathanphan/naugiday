// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_queue_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanQueueItemDto _$ScanQueueItemDtoFromJson(Map<String, dynamic> json) =>
    ScanQueueItemDto(
      id: json['id'] as String,
      scanImageId: json['scanImageId'] as String,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$ScanQueueItemDtoToJson(ScanQueueItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scanImageId': instance.scanImageId,
      'queuedAt': instance.queuedAt.toIso8601String(),
      'retryCount': instance.retryCount,
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
      'status': instance.status,
    };
