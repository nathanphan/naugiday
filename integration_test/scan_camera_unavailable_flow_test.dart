import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/repositories/scan_permission_repository.dart';
import 'package:naugiday/presentation/providers/scan_controller.dart';
import 'package:naugiday/presentation/screens/scan_screen.dart';

class _GrantedPermissionRepository implements ScanPermissionRepository {
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('camera unavailable state renders', (tester) async {
    DebugToggles.cameraMode = CameraDebugMode.unavailable;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          scanPermissionRepositoryProvider
              .overrideWith((ref) => _GrantedPermissionRepository()),
        ],
        child: const MaterialApp(
          home: ScanScreen(forceCameraUnavailable: true),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Oops! Camera Unavailable'), findsOneWidget);
    await tester.tap(find.text('Retry Camera'));
    await tester.pumpAndSettle();
    expect(find.text('Oops! Camera Unavailable'), findsOneWidget);
  });
}
