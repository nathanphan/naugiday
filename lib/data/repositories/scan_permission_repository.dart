import 'package:naugiday/data/services/scan_permission_service.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/repositories/scan_permission_repository.dart';

class ScanPermissionRepositoryImpl implements ScanPermissionRepository {
  ScanPermissionRepositoryImpl(this._service);

  final ScanPermissionService _service;

  @override
  Future<PermissionState> fetchStatus() => _service.fetchStatus();

  @override
  Future<bool> openSettings() => _service.openSettings();

  @override
  Future<PermissionState> requestCamera() => _service.requestCamera();

  @override
  Future<PermissionState> requestPhotos() => _service.requestPhotos();
}
