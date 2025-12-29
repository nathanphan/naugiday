// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TelemetryEvent _$TelemetryEventFromJson(Map<String, dynamic> json) =>
    _TelemetryEvent(
      name: json['name'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      screenName: json['screenName'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$TelemetryEventToJson(_TelemetryEvent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'screenName': instance.screenName,
      'metadata': instance.metadata,
    };
