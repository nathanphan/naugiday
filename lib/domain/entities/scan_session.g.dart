// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanSession _$ScanSessionFromJson(Map<String, dynamic> json) => _ScanSession(
  id: json['id'] as String,
  openedAt: DateTime.parse(json['openedAt'] as String),
  state: $enumDecode(_$ScanSessionStateEnumMap, json['state']),
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
  sourceScreen: json['sourceScreen'] as String?,
);

Map<String, dynamic> _$ScanSessionToJson(_ScanSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openedAt': instance.openedAt.toIso8601String(),
      'state': _$ScanSessionStateEnumMap[instance.state]!,
      'imageIds': instance.imageIds,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
      'sourceScreen': instance.sourceScreen,
    };

const _$ScanSessionStateEnumMap = {
  ScanSessionState.normal: 'normal',
  ScanSessionState.initializing: 'initializing',
  ScanSessionState.cameraUnavailable: 'cameraUnavailable',
  ScanSessionState.permissionDenied: 'permissionDenied',
  ScanSessionState.disabled: 'disabled',
};
