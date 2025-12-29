import 'package:flutter/foundation.dart';

enum SuggestionsDebugMode { normal, loading, error, empty }
enum StorageDebugMode { normal, error, empty }
enum CameraDebugMode { normal, unavailable, slow }

class DebugToggles {
  static SuggestionsDebugMode suggestionsMode = SuggestionsDebugMode.normal;
  static StorageDebugMode storageMode = StorageDebugMode.normal;
  static CameraDebugMode cameraMode = CameraDebugMode.normal;
  static bool enableDiagnosticsLogging = false;

  static void reset() {
    if (kReleaseMode) return;
    suggestionsMode = SuggestionsDebugMode.normal;
    storageMode = StorageDebugMode.normal;
    cameraMode = CameraDebugMode.normal;
    enableDiagnosticsLogging = false;
  }
}
