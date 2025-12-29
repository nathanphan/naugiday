import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/repositories/telemetry_repository.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';
import 'package:naugiday/data/services/telemetry_service.dart';
import 'package:naugiday/domain/entities/telemetry_event.dart';

class _FakeTelemetryService extends TelemetryService {
  int sentBatches = 0;
  int queuedEvents = 0;

  @override
  Future<void> sendEventBatch(List<TelemetryEventRecord> events) async {
    sentBatches += 1;
  }

  @override
  Future<void> enqueueEvent(TelemetryEventRecord event) async {
    queuedEvents += 1;
  }
}

void main() {
  test('filters out non-allowed events', () async {
    final service = _FakeTelemetryService();
    final repo = TelemetryRepositoryImpl(service);

    await repo.recordEvent(
      TelemetryEvent(name: 'unexpected_event', occurredAt: DateTime.now()),
    );

    expect(service.sentBatches, 0);
    expect(service.queuedEvents, 0);
  });

  test('allows configured events', () async {
    final service = _FakeTelemetryService();
    final repo = TelemetryRepositoryImpl(service);

    await repo.recordEvent(
      TelemetryEvent(name: 'screen_view', occurredAt: DateTime.now()),
    );

    expect(service.sentBatches, 1);
  });
}
