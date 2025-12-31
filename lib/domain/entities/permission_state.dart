import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission_state.freezed.dart';
part 'permission_state.g.dart';

enum PermissionAccessStatus { granted, denied, restricted, limited, unknown }

@freezed
abstract class PermissionState with _$PermissionState {
  const PermissionState._();

  const factory PermissionState({
    required PermissionAccessStatus cameraStatus,
    required PermissionAccessStatus photoStatus,
    required DateTime lastCheckedAt,
  }) = _PermissionState;

  factory PermissionState.fromJson(Map<String, dynamic> json) =>
      _$PermissionStateFromJson(json);
}
