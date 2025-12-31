import 'dart:io';

import 'package:camera/camera.dart';
import 'package:naugiday/data/repositories/scan_permission_repository.dart';
import 'package:naugiday/data/repositories/scan_queue_repository.dart';
import 'package:naugiday/data/services/scan_image_picker.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/entities/scan_session.dart';
import 'package:naugiday/domain/errors/scan_storage_exception.dart';
import 'package:naugiday/domain/repositories/scan_permission_repository.dart';
import 'package:naugiday/domain/repositories/scan_queue_repository.dart';
import 'package:naugiday/domain/usecases/evaluate_scan_state.dart';
import 'package:naugiday/domain/usecases/queue_scan_image.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/data/services/scan_permission_service.dart';
import 'package:naugiday/data/services/scan_image_storage.dart';
import 'package:naugiday/data/services/crash_reporting_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'scan_controller.g.dart';

typedef ScanNetworkLookup = Future<List<InternetAddress>> Function(String host);

class ScanControllerState {
  final ScanSessionState sessionState;
  final List<ScanImage> images;
  final PermissionState permissionState;
  final bool cameraAvailable;
  final bool isInitializing;
  final bool isOffline;
  final bool isFeatureEnabled;
  final String? errorMessage;

  const ScanControllerState({
    required this.sessionState,
    required this.images,
    required this.permissionState,
    required this.cameraAvailable,
    required this.isInitializing,
    required this.isOffline,
    required this.isFeatureEnabled,
    this.errorMessage,
  });

  ScanControllerState copyWith({
    ScanSessionState? sessionState,
    List<ScanImage>? images,
    PermissionState? permissionState,
    bool? cameraAvailable,
    bool? isInitializing,
    bool? isOffline,
    bool? isFeatureEnabled,
    String? errorMessage,
  }) {
    return ScanControllerState(
      sessionState: sessionState ?? this.sessionState,
      images: images ?? this.images,
      permissionState: permissionState ?? this.permissionState,
      cameraAvailable: cameraAvailable ?? this.cameraAvailable,
      isInitializing: isInitializing ?? this.isInitializing,
      isOffline: isOffline ?? this.isOffline,
      isFeatureEnabled: isFeatureEnabled ?? this.isFeatureEnabled,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
ScanQueueRepository scanQueueRepository(Ref ref) {
  return ScanQueueRepositoryImpl(ScanImageStorage());
}

@riverpod
ScanPermissionRepository scanPermissionRepository(Ref ref) {
  return ScanPermissionRepositoryImpl(ScanPermissionService());
}

@riverpod
ScanImagePicker scanImagePicker(Ref ref) {
  return ScanImagePicker();
}

@riverpod
ScanNetworkLookup scanNetworkLookup(Ref ref) {
  return InternetAddress.lookup;
}

@riverpod
class ScanController extends _$ScanController {
  final _uuid = const Uuid();
  late final ScanQueueRepository _queueRepository;
  late final ScanPermissionRepository _permissionRepository;
  late final ScanImagePicker _imagePicker;
  late final QueueScanImage _queueScanImage;
  late final EvaluateScanState _evaluateScanState;
  bool _hasInitialized = false;

  @override
  ScanControllerState build() {
    _queueRepository = ref.watch(scanQueueRepositoryProvider);
    _permissionRepository = ref.watch(scanPermissionRepositoryProvider);
    _imagePicker = ref.watch(scanImagePickerProvider);
    _queueScanImage = QueueScanImage(_queueRepository);
    _evaluateScanState = EvaluateScanState();
    final permissionState = PermissionState(
      cameraStatus: PermissionAccessStatus.unknown,
      photoStatus: PermissionAccessStatus.unknown,
      lastCheckedAt: DateTime.now(),
    );
    final initialState = ScanControllerState(
      sessionState: ScanSessionState.initializing,
      images: const [],
      permissionState: permissionState,
      cameraAvailable: true,
      isInitializing: true,
      isOffline: false,
      isFeatureEnabled: true,
    );
    if (!_hasInitialized) {
      _hasInitialized = true;
      Future.microtask(refreshPermissions);
    }
    return initialState;
  }

  Future<void> refreshPermissions() async {
    try {
      final updated = await _permissionRepository.fetchStatus();
      if (!ref.mounted) return;
      _applyState(permissionState: updated);
    } catch (err, stack) {
      CrashReportingService.recordError(err, stack);
    }
  }

  void updateFeatureEnabled(bool enabled) {
    _applyState(isFeatureEnabled: enabled);
  }

  void setOffline(bool value) {
    _applyState(isOffline: value);
  }

  void setCameraStatus({required bool available, required bool initializing}) {
    _applyState(cameraAvailable: available, isInitializing: initializing);
  }

  Future<void> addCapturedImage(XFile file) async {
    final image = _buildScanImage(
      source: ScanImageSource.camera,
      path: file.path,
    );
    await _persistScanImage(image);
    await _recordEvent('capture_photo');
  }

  Future<void> pickFromGallery() async {
    try {
      final picked = await _imagePicker.pickFromGallery();
      if (picked == null) return;
      final image = _buildScanImage(
        source: ScanImageSource.gallery,
        path: picked.path,
      );
      await _persistScanImage(image);
      await _recordEvent('pick_gallery');
    } catch (err, stack) {
      CrashReportingService.recordError(err, stack);
      _setError('Unable to open your photo library. Please try again.');
    }
  }

  void removeImage(String id) {
    final updated = state.images.where((image) => image.id != id).toList();
    state = state.copyWith(images: updated);
  }

  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(errorMessage: null);
  }

  Future<void> retryQueued() async {
    final offline = await _checkOffline();
    if (!ref.mounted) return;
    state = state.copyWith(isOffline: offline);
    if (offline) {
      _setError('Still offline. We will retry when back online.');
      return;
    }
    final updated = state.images.map((image) {
      if (image.status == ScanImageStatus.queued ||
          image.status == ScanImageStatus.failed) {
        return image.copyWith(status: ScanImageStatus.processed);
      }
      return image;
    }).toList(growable: false);
    if (!ref.mounted) return;
    state = state.copyWith(images: updated);
    await _recordEvent('scan_retry');
  }

  Future<void> _persistScanImage(ScanImage image) async {
    try {
      final offline = await _checkOffline();
      if (!ref.mounted) return;
      state = state.copyWith(isOffline: offline);
      final persisted = await _queueScanImage(image);
      if (!ref.mounted) return;
      final status = state.isOffline
          ? ScanImageStatus.queued
          : ScanImageStatus.processed;
      final updated = persisted.copyWith(status: status);
      state = state.copyWith(images: [...state.images, updated]);
    } on ScanStorageException catch (err) {
      _setError(err.message);
    } catch (err, stack) {
      CrashReportingService.recordError(err, stack);
      _setError('Unable to save image. Please try again.');
    }
  }

  Future<bool> _checkOffline() async {
    try {
      final lookup = ref.read(scanNetworkLookupProvider);
      final result = await lookup('example.com')
          .timeout(const Duration(seconds: 1));
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return true;
    }
  }

  void _applyState({
    PermissionState? permissionState,
    bool? cameraAvailable,
    bool? isInitializing,
    bool? isOffline,
    bool? isFeatureEnabled,
  }) {
    final nextPermission = permissionState ?? state.permissionState;
    final nextCameraAvailable = cameraAvailable ?? state.cameraAvailable;
    final nextInitializing = isInitializing ?? state.isInitializing;
    final nextFeatureEnabled = isFeatureEnabled ?? state.isFeatureEnabled;
    final nextState = _evaluateScanState(
      isEnabled: nextFeatureEnabled,
      isInitializing: nextInitializing,
      cameraAvailable: nextCameraAvailable,
      permissionState: nextPermission,
    );
    state = state.copyWith(
      sessionState: nextState,
      permissionState: nextPermission,
      cameraAvailable: nextCameraAvailable,
      isInitializing: nextInitializing,
      isOffline: isOffline ?? state.isOffline,
      isFeatureEnabled: nextFeatureEnabled,
    );
  }

  ScanImage _buildScanImage({
    required ScanImageSource source,
    required String path,
  }) {
    return ScanImage(
      id: _uuid.v4(),
      source: source,
      path: path,
      sizeBytes: 0,
      createdAt: DateTime.now(),
      status: ScanImageStatus.queued,
    );
  }

  Future<void> _recordEvent(String name) async {
    await ref.read(telemetryControllerProvider.notifier).recordCta(name);
  }

  void _setError(String message) {
    state = state.copyWith(errorMessage: message);
  }
}
