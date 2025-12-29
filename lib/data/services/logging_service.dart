import 'package:flutter/foundation.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';

class LoggingService {
  static void log(String message) {
    if (!_isEnabled()) return;
    debugPrint('[Diagnostics] $message');
  }

  static bool _isEnabled() {
    if (kReleaseMode) return false;
    return DebugToggles.enableDiagnosticsLogging;
  }
}
