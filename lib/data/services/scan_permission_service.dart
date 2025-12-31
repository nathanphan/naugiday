import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanPermissionService {
  Future<PermissionState> fetchStatus() async {
    final camera = await Permission.camera.status;
    final photos = await Permission.photos.status;
    return PermissionState(
      cameraStatus: _mapStatus(camera),
      photoStatus: _mapStatus(photos),
      lastCheckedAt: DateTime.now(),
    );
  }

  Future<PermissionState> requestCamera() async {
    await Permission.camera.request();
    return fetchStatus();
  }

  Future<PermissionState> requestPhotos() async {
    await Permission.photos.request();
    return fetchStatus();
  }

  Future<bool> openSettings() async {
    return openAppSettings();
  }

  PermissionAccessStatus _mapStatus(PermissionStatus status) {
    if (status.isGranted) return PermissionAccessStatus.granted;
    if (status.isLimited) return PermissionAccessStatus.limited;
    if (status.isRestricted) return PermissionAccessStatus.restricted;
    if (status.isPermanentlyDenied) return PermissionAccessStatus.denied;
    if (status.isDenied) return PermissionAccessStatus.denied;
    return PermissionAccessStatus.unknown;
  }
}
