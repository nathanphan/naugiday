import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/repositories/scan_queue_repository.dart';

class QueueScanImage {
  QueueScanImage(this._repository);

  final ScanQueueRepository _repository;

  Future<ScanImage> call(ScanImage image) {
    return _repository.enqueue(image);
  }
}
