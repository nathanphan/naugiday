import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/entities/scan_session.dart';

class EvaluateScanState {
  ScanSessionState call({
    required bool isEnabled,
    required bool isInitializing,
    required bool cameraAvailable,
    required PermissionState permissionState,
  }) {
    if (!isEnabled) {
      return ScanSessionState.disabled;
    }
    final cameraStatus = permissionState.cameraStatus;
    if (cameraStatus == PermissionAccessStatus.denied ||
        cameraStatus == PermissionAccessStatus.restricted) {
      return ScanSessionState.permissionDenied;
    }
    if (isInitializing) {
      return ScanSessionState.initializing;
    }
    if (!cameraAvailable) {
      return ScanSessionState.cameraUnavailable;
    }
    return ScanSessionState.normal;
  }
}
