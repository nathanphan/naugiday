import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry_event.freezed.dart';
part 'telemetry_event.g.dart';

@freezed
abstract class TelemetryEvent with _$TelemetryEvent {
  const TelemetryEvent._();

  const factory TelemetryEvent({
    required String name,
    required DateTime occurredAt,
    String? screenName,
    Map<String, String>? metadata,
  }) = _TelemetryEvent;

  factory TelemetryEvent.fromJson(Map<String, dynamic> json) =>
      _$TelemetryEventFromJson(json);
}
