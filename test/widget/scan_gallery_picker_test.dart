import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/services/scan_image_picker.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/entities/scan_queue_item.dart';
import 'package:naugiday/domain/repositories/scan_permission_repository.dart';
import 'package:naugiday/domain/repositories/scan_queue_repository.dart';
import 'package:naugiday/presentation/providers/scan_controller.dart';

class _StubQueueRepository implements ScanQueueRepository {
  @override
  Future<ScanImage> enqueue(ScanImage image) async {
    return image.copyWith(status: ScanImageStatus.processed);
  }

  @override
  Future<List<ScanQueueItem>> fetchQueue() async => const [];

  @override
  Future<void> removeQueueItem(String id) async {}

  @override
  Future<void> updateQueueItem(ScanQueueItem item) async {}
}

class _StubPermissionRepository implements ScanPermissionRepository {
  @override
  Future<PermissionState> fetchStatus() async {
    return PermissionState(
      cameraStatus: PermissionAccessStatus.granted,
      photoStatus: PermissionAccessStatus.granted,
      lastCheckedAt: DateTime(2024, 1, 1),
    );
  }

  @override
  Future<bool> openSettings() async => true;

  @override
  Future<PermissionState> requestCamera() => fetchStatus();

  @override
  Future<PermissionState> requestPhotos() => fetchStatus();
}

class _StubImagePicker extends ScanImagePicker {
  _StubImagePicker(this.filePath);

  final String filePath;

  @override
  Future<XFile?> pickFromGallery() async {
    return XFile(filePath);
  }
}

class _GalleryHarness extends ConsumerWidget {
  const _GalleryHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanControllerProvider);
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('count:${state.images.length}', key: const ValueKey('count')),
            FilledButton(
              onPressed: () =>
                  ref.read(scanControllerProvider.notifier).pickFromGallery(),
              child: const Text('Pick'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('gallery picker adds an image to state', (tester) async {
    const filePath = '/tmp/scan_gallery_test.jpg';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          scanQueueRepositoryProvider.overrideWith((ref) => _StubQueueRepository()),
          scanPermissionRepositoryProvider
              .overrideWith((ref) => _StubPermissionRepository()),
          scanImagePickerProvider.overrideWith(
            (ref) => _StubImagePicker(filePath),
          ),
          scanNetworkLookupProvider.overrideWith(
            (ref) => (_) async => [InternetAddress.loopbackIPv4],
          ),
        ],
        child: const _GalleryHarness(),
      ),
    );

    expect(find.byKey(const ValueKey('count')), findsOneWidget);
    expect(find.text('count:0'), findsOneWidget);

    await tester.tap(find.text('Pick'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('count:1'), findsOneWidget);
  });
}
