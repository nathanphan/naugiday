import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/scan_queue_item.dart';

part 'scan_queue_item_dto.g.dart';

@JsonSerializable()
class ScanQueueItemDto {
  final String id;
  final String scanImageId;
  final DateTime queuedAt;
  final int retryCount;
  final DateTime? lastAttemptAt;
  final String status;

  ScanQueueItemDto({
    required this.id,
    required this.scanImageId,
    required this.queuedAt,
    this.retryCount = 0,
    this.lastAttemptAt,
    required this.status,
  });

  factory ScanQueueItemDto.fromDomain(ScanQueueItem item) {
    return ScanQueueItemDto(
      id: item.id,
      scanImageId: item.scanImageId,
      queuedAt: item.queuedAt,
      retryCount: item.retryCount,
      lastAttemptAt: item.lastAttemptAt,
      status: item.status.name,
    );
  }

  ScanQueueItem toDomain() {
    final parsedStatus = ScanQueueStatus.values.firstWhere(
      (value) => value.name == status,
      orElse: () => ScanQueueStatus.queued,
    );
    return ScanQueueItem(
      id: id,
      scanImageId: scanImageId,
      queuedAt: queuedAt,
      retryCount: retryCount,
      lastAttemptAt: lastAttemptAt,
      status: parsedStatus,
    );
  }

  factory ScanQueueItemDto.fromJson(Map<String, dynamic> json) =>
      _$ScanQueueItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScanQueueItemDtoToJson(this);
}
