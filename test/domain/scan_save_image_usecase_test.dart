import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/entities/scan_queue_item.dart';
import 'package:naugiday/domain/repositories/scan_queue_repository.dart';
import 'package:naugiday/domain/usecases/queue_scan_image.dart';

class _StubQueueRepository implements ScanQueueRepository {
  ScanImage? lastImage;

  @override
  Future<ScanImage> enqueue(ScanImage image) async {
    lastImage = image;
    return image.copyWith(status: ScanImageStatus.queued);
  }

  @override
  Future<List<ScanQueueItem>> fetchQueue() async => const [];

  @override
  Future<void> removeQueueItem(String id) async {}

  @override
  Future<void> updateQueueItem(ScanQueueItem item) async {}
}

void main() {
  test('queue scan image returns stored image', () async {
    final repo = _StubQueueRepository();
    final usecase = QueueScanImage(repo);
    final image = ScanImage(
      id: 'img1',
      source: ScanImageSource.camera,
      path: '/tmp/photo.jpg',
      sizeBytes: 0,
      createdAt: DateTime(2024, 1, 1),
      status: ScanImageStatus.queued,
    );

    final stored = await usecase(image);

    expect(repo.lastImage, isNotNull);
    expect(stored.status, ScanImageStatus.queued);
  });
}
