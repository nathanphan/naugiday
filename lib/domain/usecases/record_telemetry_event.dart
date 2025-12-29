import 'package:naugiday/domain/entities/telemetry_event.dart';
import 'package:naugiday/domain/repositories/telemetry_repository.dart';

class RecordTelemetryEvent {
  final TelemetryRepository _repository;

  RecordTelemetryEvent(this._repository);

  Future<void> call(TelemetryEvent event) {
    return _repository.recordEvent(event);
  }
}
