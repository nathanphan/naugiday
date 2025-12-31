import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/entities/scan_queue_item.dart';

abstract class ScanQueueRepository {
  Future<ScanImage> enqueue(ScanImage image);
  Future<List<ScanQueueItem>> fetchQueue();
  Future<void> updateQueueItem(ScanQueueItem item);
  Future<void> removeQueueItem(String id);
}
