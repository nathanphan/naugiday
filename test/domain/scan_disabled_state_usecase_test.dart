import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/entities/scan_session.dart';
import 'package:naugiday/domain/usecases/evaluate_scan_state.dart';

void main() {
  test('disabled flag forces disabled state', () {
    final usecase = EvaluateScanState();
    final state = usecase(
      isEnabled: false,
      isInitializing: false,
      cameraAvailable: true,
      permissionState: PermissionState(
        cameraStatus: PermissionAccessStatus.granted,
        photoStatus: PermissionAccessStatus.granted,
        lastCheckedAt: DateTime(2024, 1, 1),
      ),
    );

    expect(state, ScanSessionState.disabled);
  });
}
