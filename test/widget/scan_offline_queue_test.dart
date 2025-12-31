import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/presentation/widgets/scan_preview_sheet.dart';

void main() {
  testWidgets('offline queued status message is shown', (tester) async {
    final images = [
      ScanImage(
        id: 'img1',
        source: ScanImageSource.camera,
        path: '/tmp/scan_offline.png',
        sizeBytes: 0,
        createdAt: DateTime(2024, 1, 1),
        status: ScanImageStatus.queued,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScanPreviewSheet(
            images: images,
            isOffline: true,
            onGenerate: () {},
            onDelete: (_) {},
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(
      find.text('Saved offline. We will process when you are back online.'),
      findsOneWidget,
    );
  });
}
