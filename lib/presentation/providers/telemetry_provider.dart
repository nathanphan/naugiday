import 'package:naugiday/data/repositories/telemetry_repository.dart';
import 'package:naugiday/data/services/telemetry_service.dart';
import 'package:naugiday/domain/entities/telemetry_event.dart';
import 'package:naugiday/domain/repositories/telemetry_repository.dart';
import 'package:naugiday/domain/usecases/record_telemetry_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telemetry_provider.g.dart';

@riverpod
TelemetryRepository telemetryRepository(Ref ref) {
  return TelemetryRepositoryImpl(TelemetryService());
}

@riverpod
class TelemetryController extends _$TelemetryController {
  late final RecordTelemetryEvent _recordEvent;
  late final TelemetryRepository _repository;

  @override
  bool build() {
    _repository = ref.watch(telemetryRepositoryProvider);
    _recordEvent = RecordTelemetryEvent(_repository);
    return true;
  }

  Future<void> recordScreenView(String screenName) async {
    final event = TelemetryEvent(
      name: 'screen_view',
      occurredAt: DateTime.now(),
      screenName: screenName,
    );
    await _recordEvent(event);
  }

  Future<void> recordCta(String name) async {
    final event = TelemetryEvent(
      name: name,
      occurredAt: DateTime.now(),
    );
    await _recordEvent(event);
  }

  Future<void> flushPending() async {
    await _repository.flushPending();
  }
}
