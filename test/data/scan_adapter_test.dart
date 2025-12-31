import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:naugiday/data/adapters/scan_image_adapter.dart';
import 'package:naugiday/data/adapters/scan_queue_item_adapter.dart';
import 'package:naugiday/data/dtos/scan_image_dto.dart';
import 'package:naugiday/data/dtos/scan_queue_item_dto.dart';

void main() {
  const imageBoxName = 'scan_image_adapter_test';
  const queueBoxName = 'scan_queue_adapter_test';
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('scan_adapter_test');
    Hive.init(tempDir.path);
    final imageAdapter = ScanImageDtoAdapter();
    final queueAdapter = ScanQueueItemDtoAdapter();
    if (!Hive.isAdapterRegistered(imageAdapter.typeId)) {
      Hive.registerAdapter(imageAdapter);
    }
    if (!Hive.isAdapterRegistered(queueAdapter.typeId)) {
      Hive.registerAdapter(queueAdapter);
    }
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(imageBoxName);
    await Hive.deleteBoxFromDisk(queueBoxName);
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('scan image dto round-trips through Hive adapter', () async {
    final box = await Hive.openBox<ScanImageDto>(imageBoxName);
    final image = ScanImageDto(
      id: 'img-1',
      source: 'camera',
      path: '/tmp/image.jpg',
      thumbnailPath: null,
      sizeBytes: 1024,
      createdAt: DateTime(2024, 1, 1),
      status: 'queued',
      failureReason: null,
    );

    await box.put(image.id, image);
    final stored = box.get(image.id);

    expect(stored, isNotNull);
    expect(stored!.source, 'camera');
    expect(stored.sizeBytes, 1024);
  });

  test('scan queue dto round-trips through Hive adapter', () async {
    final box = await Hive.openBox<ScanQueueItemDto>(queueBoxName);
    final item = ScanQueueItemDto(
      id: 'q1',
      scanImageId: 'img-1',
      queuedAt: DateTime(2024, 1, 1),
      retryCount: 1,
      lastAttemptAt: null,
      status: 'queued',
    );

    await box.put(item.id, item);
    final stored = box.get(item.id);

    expect(stored, isNotNull);
    expect(stored!.scanImageId, 'img-1');
    expect(stored.retryCount, 1);
  });
}
