import 'package:naugiday/domain/entities/permission_state.dart';

abstract class ScanPermissionRepository {
  Future<PermissionState> fetchStatus();
  Future<PermissionState> requestCamera();
  Future<PermissionState> requestPhotos();
  Future<bool> openSettings();
}
