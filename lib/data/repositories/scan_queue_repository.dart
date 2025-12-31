import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/scan_constants.dart';
import 'package:naugiday/data/dtos/scan_image_dto.dart';
import 'package:naugiday/data/dtos/scan_queue_item_dto.dart';
import 'package:naugiday/data/services/scan_image_storage.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/entities/scan_queue_item.dart';
import 'package:naugiday/domain/repositories/scan_queue_repository.dart';
import 'package:uuid/uuid.dart';

class ScanQueueRepositoryImpl implements ScanQueueRepository {
  ScanQueueRepositoryImpl(this._storage, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final ScanImageStorage _storage;
  final Uuid _uuid;

  @override
  Future<ScanImage> enqueue(ScanImage image) async {
    final imagesBox = Hive.box(scanImagesBoxName);
    final queueBox = Hive.box(scanQueueBoxName);
    final persisted = await _storage.persistIfNeeded(image);
    final imageDto = ScanImageDto.fromDomain(persisted);
    await imagesBox.put(persisted.id, imageDto);
    final queueItem = ScanQueueItem(
      id: _uuid.v4(),
      scanImageId: persisted.id,
      queuedAt: DateTime.now(),
      status: ScanQueueStatus.queued,
    );
    await queueBox.put(queueItem.id, ScanQueueItemDto.fromDomain(queueItem));
    return persisted;
  }

  @override
  Future<List<ScanQueueItem>> fetchQueue() async {
    final queueBox = Hive.box(scanQueueBoxName);
    return queueBox.values
        .whereType<ScanQueueItemDto>()
        .map((dto) => dto.toDomain())
        .toList(growable: false);
  }

  @override
  Future<void> updateQueueItem(ScanQueueItem item) async {
    final queueBox = Hive.box(scanQueueBoxName);
    await queueBox.put(item.id, ScanQueueItemDto.fromDomain(item));
  }

  @override
  Future<void> removeQueueItem(String id) async {
    final queueBox = Hive.box(scanQueueBoxName);
    await queueBox.delete(id);
  }
}
