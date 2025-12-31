import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/scan_queue_item_dto.dart';

const int scanQueueItemTypeId = 9;

class ScanQueueItemDtoAdapter extends TypeAdapter<ScanQueueItemDto> {
  @override
  final int typeId = scanQueueItemTypeId;

  @override
  ScanQueueItemDto read(BinaryReader reader) {
    final id = reader.readString();
    final scanImageId = reader.readString();
    final queuedAt = reader.read() as DateTime;
    final retryCount = reader.availableBytes > 0 ? reader.readInt() : 0;
    final lastAttemptAt =
        reader.availableBytes > 0 ? reader.read() as DateTime? : null;
    final status = reader.availableBytes > 0 ? reader.readString() : 'queued';
    return ScanQueueItemDto(
      id: id,
      scanImageId: scanImageId,
      queuedAt: queuedAt,
      retryCount: retryCount,
      lastAttemptAt: lastAttemptAt,
      status: status,
    );
  }

  @override
  void write(BinaryWriter writer, ScanQueueItemDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.scanImageId)
      ..write(obj.queuedAt)
      ..writeInt(obj.retryCount)
      ..write(obj.lastAttemptAt)
      ..writeString(obj.status);
  }
}
