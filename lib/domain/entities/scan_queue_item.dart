import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_queue_item.freezed.dart';
part 'scan_queue_item.g.dart';

enum ScanQueueStatus { queued, processing, failed }

@freezed
abstract class ScanQueueItem with _$ScanQueueItem {
  const ScanQueueItem._();

  const factory ScanQueueItem({
    required String id,
    required String scanImageId,
    required DateTime queuedAt,
    @Default(0) int retryCount,
    DateTime? lastAttemptAt,
    required ScanQueueStatus status,
  }) = _ScanQueueItem;

  factory ScanQueueItem.fromJson(Map<String, dynamic> json) =>
      _$ScanQueueItemFromJson(json);
}
