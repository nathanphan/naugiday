import 'package:naugiday/domain/entities/telemetry_event.dart';

abstract class TelemetryRepository {
  Future<void> recordEvent(TelemetryEvent event);
  Future<void> flushPending();
}
