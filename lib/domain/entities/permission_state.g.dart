// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermissionState _$PermissionStateFromJson(Map<String, dynamic> json) =>
    _PermissionState(
      cameraStatus: $enumDecode(
        _$PermissionAccessStatusEnumMap,
        json['cameraStatus'],
      ),
      photoStatus: $enumDecode(
        _$PermissionAccessStatusEnumMap,
        json['photoStatus'],
      ),
      lastCheckedAt: DateTime.parse(json['lastCheckedAt'] as String),
    );

Map<String, dynamic> _$PermissionStateToJson(_PermissionState instance) =>
    <String, dynamic>{
      'cameraStatus': _$PermissionAccessStatusEnumMap[instance.cameraStatus]!,
      'photoStatus': _$PermissionAccessStatusEnumMap[instance.photoStatus]!,
      'lastCheckedAt': instance.lastCheckedAt.toIso8601String(),
    };

const _$PermissionAccessStatusEnumMap = {
  PermissionAccessStatus.granted: 'granted',
  PermissionAccessStatus.denied: 'denied',
  PermissionAccessStatus.restricted: 'restricted',
  PermissionAccessStatus.limited: 'limited',
  PermissionAccessStatus.unknown: 'unknown',
};
