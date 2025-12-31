import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/repositories/scan_permission_repository.dart';
import 'package:naugiday/presentation/providers/scan_controller.dart';
import 'package:naugiday/presentation/screens/scan_screen.dart';

class _DeniedPermissionRepository implements ScanPermissionRepository {
  @override
  Future<PermissionState> fetchStatus() async {
    return PermissionState(
      cameraStatus: PermissionAccessStatus.denied,
      photoStatus: PermissionAccessStatus.denied,
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

void main() {
  testWidgets('permission denied shows guidance and settings', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          scanPermissionRepositoryProvider
              .overrideWith((ref) => _DeniedPermissionRepository()),
        ],
        child: const MaterialApp(
          home: ScanScreen(forceCameraUnavailable: true),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Camera Access is Off'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
  });
}
