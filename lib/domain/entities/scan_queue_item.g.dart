// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanQueueItem _$ScanQueueItemFromJson(Map<String, dynamic> json) =>
    _ScanQueueItem(
      id: json['id'] as String,
      scanImageId: json['scanImageId'] as String,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
      status: $enumDecode(_$ScanQueueStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$ScanQueueItemToJson(_ScanQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scanImageId': instance.scanImageId,
      'queuedAt': instance.queuedAt.toIso8601String(),
      'retryCount': instance.retryCount,
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
      'status': _$ScanQueueStatusEnumMap[instance.status]!,
    };

const _$ScanQueueStatusEnumMap = {
  ScanQueueStatus.queued: 'queued',
  ScanQueueStatus.processing: 'processing',
  ScanQueueStatus.failed: 'failed',
};
