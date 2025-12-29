import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';
import 'package:naugiday/data/services/telemetry_service.dart';
import 'package:naugiday/domain/entities/telemetry_event.dart';
import 'package:naugiday/domain/repositories/telemetry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  TelemetryRepositoryImpl(this._telemetryService);

  final TelemetryService _telemetryService;
  static const Set<String> _allowedEvents = {
    'screen_view',
    'scan_ingredients',
    'save_recipe',
    'generate_recipe',
  };

  @override
  Future<void> recordEvent(TelemetryEvent event) async {
    if (!_allowedEvents.contains(event.name)) {
      return;
    }
    final record = TelemetryEventRecord(
      name: event.name,
      occurredAt: event.occurredAt,
      screenName: event.screenName,
      metadata: event.metadata,
    );
    try {
      await _telemetryService.sendEventBatch([record]);
    } catch (_) {
      await _telemetryService.enqueueEvent(record);
    }
  }

  @override
  Future<void> flushPending() async {
    if (!Hive.isBoxOpen(telemetryQueueBoxName)) {
      return;
    }
    final box = Hive.box(telemetryQueueBoxName);
    final queue = box.get('queue') as List<dynamic>? ?? <dynamic>[];
    if (queue.isEmpty) return;
    await _telemetryService.flushPending();
  }
}
