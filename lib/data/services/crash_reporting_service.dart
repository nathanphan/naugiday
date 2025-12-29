import 'dart:async';

import 'package:flutter/foundation.dart';

class CrashReportingService {
  static Future<void> initialize() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      recordFlutterError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack);
      return true;
    };
  }

  static void recordFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) return;
    // TODO: forward to crash reporting backend via server proxy.
  }

  static void recordError(Object error, StackTrace stack) {
    if (kDebugMode) return;
    // TODO: forward to crash reporting backend via server proxy.
  }
}
