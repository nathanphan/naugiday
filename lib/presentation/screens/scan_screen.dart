import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/permission_state.dart';
import 'package:naugiday/domain/entities/scan_session.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/scan_controller.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/data/services/crash_reporting_service.dart';
import 'package:naugiday/presentation/widgets/camera_controls_overlay.dart';
import 'package:naugiday/presentation/widgets/scan_preview_sheet.dart';
import 'package:naugiday/presentation/widgets/skeletons.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key, this.forceCameraUnavailable = false});

  final bool forceCameraUnavailable;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isFlashOn = false;
  bool _loggedOpen = false;
  bool _loggedPermissionDenied = false;
  bool _loggedDisabled = false;
  late final ProviderSubscription<ScanControllerState> _scanSubscription;
  late final ProviderSubscription<AsyncValue<FeatureFlagState>>
      _featureFlagSubscription;

  @override
  void initState() {
    super.initState();
    _scanSubscription = ref.listenManual(
      scanControllerProvider,
      (previous, next) {
        if (!mounted) return;
        final message = next.errorMessage;
        if (message == null) return;
        if (previous?.errorMessage == message) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        ref.read(scanControllerProvider.notifier).clearError();
        if (previous?.sessionState == next.sessionState) return;
        if (next.sessionState == ScanSessionState.disabled) {
          _recordScanDisabled();
        }
        if (next.sessionState == ScanSessionState.permissionDenied) {
          _recordPermissionDenied();
        }
      },
    );
    _featureFlagSubscription = ref.listenManual(
      featureFlagControllerProvider,
      (previous, next) {
        if (!mounted) return;
        _applyFeatureFlags(next);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _recordScanOpen();
      _applyFeatureFlags(ref.read(featureFlagControllerProvider));
      if (widget.forceCameraUnavailable) {
        ref
            .read(scanControllerProvider.notifier)
            .setCameraStatus(available: false, initializing: false);
      } else {
        _initCamera();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scanSubscription.close();
    _featureFlagSubscription.close();
    super.dispose();
  }

  Future<void> _initCamera() async {
    if (!mounted) return;
    ref
        .read(scanControllerProvider.notifier)
        .setCameraStatus(available: true, initializing: true);
    try {
      if (DebugToggles.cameraMode == CameraDebugMode.unavailable) {
        if (mounted) {
          ref
              .read(scanControllerProvider.notifier)
              .setCameraStatus(available: false, initializing: false);
        }
        return;
      }
      if (DebugToggles.cameraMode == CameraDebugMode.slow) {
        await Future.delayed(const Duration(seconds: 2));
      }
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          ref
              .read(scanControllerProvider.notifier)
              .setCameraStatus(available: true, initializing: false);
        }
      } else {
        if (mounted) {
          ref
              .read(scanControllerProvider.notifier)
              .setCameraStatus(available: false, initializing: false);
        }
      }
    } catch (_) {
      if (mounted) {
        ref
            .read(scanControllerProvider.notifier)
            .setCameraStatus(available: false, initializing: false);
      }
    }
  }

  void _recordScanOpen() {
    if (_loggedOpen) return;
    if (!mounted) return;
    _loggedOpen = true;
    ref.read(telemetryControllerProvider.notifier).recordCta('scan_open');
  }

  void _recordScanDisabled() {
    if (_loggedDisabled) return;
    if (!mounted) return;
    _loggedDisabled = true;
    ref.read(telemetryControllerProvider.notifier).recordCta('scan_disabled');
  }

  void _recordPermissionDenied() {
    if (_loggedPermissionDenied) return;
    if (!mounted) return;
    _loggedPermissionDenied = true;
    ref
        .read(telemetryControllerProvider.notifier)
        .recordCta('permission_denied');
  }

  void _applyFeatureFlags(AsyncValue<FeatureFlagState> flagsAsync) {
    final scanEnabled = flagsAsync.asData?.value.scanEnabled ?? true;
    final scanState = ref.read(scanControllerProvider);
    if (scanEnabled == scanState.isFeatureEnabled) return;
    ref.read(scanControllerProvider.notifier).updateFeatureEnabled(scanEnabled);
  }


  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      await ref.read(scanControllerProvider.notifier).addCapturedImage(image);
    } catch (err, stack) {
      CrashReportingService.recordError(err, stack);
      ref.read(scanControllerProvider.notifier).clearError();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to capture photo.')),
      );
    }
  }

  void _toggleFlash() {
    if (_controller == null) return;
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  void _showHelpSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to scan', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'Point your camera at ingredients with good lighting and keep them within the frame.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'You can also pick a photo from your gallery to continue.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }

  void _generateRecipes(List<String> imagePaths) {
    final mealType =
        GoRouterState.of(context).extra as MealType? ?? MealType.dinner;
    context.go(
      '/suggestions',
      extra: {
        'images': imagePaths,
        'labels': const <String>[],
        'mealType': mealType,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);
    switch (scanState.sessionState) {
      case ScanSessionState.disabled:
        return _buildDisabledState(context);
      case ScanSessionState.permissionDenied:
        return _buildPermissionDenied(context, scanState.permissionState);
      case ScanSessionState.cameraUnavailable:
        return _buildCameraUnavailable(context, scanState.permissionState);
      case ScanSessionState.initializing:
        return _buildInitializing(context);
      case ScanSessionState.normal:
        return _buildNormalState(context, scanState);
    }
  }

  Widget _buildInitializing(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        color: colorScheme.surface,
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SkeletonBlock(height: 48, width: 48, shimmer: true),
                  const SizedBox(height: 16),
                  Text(
                    'Warming up the kitchen...',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Starting camera, get your ingredients ready!',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraUnavailable(
    BuildContext context,
    PermissionState permissionState,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final canUseGallery = permissionState.photoStatus ==
            PermissionAccessStatus.granted ||
        permissionState.photoStatus == PermissionAccessStatus.limited;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ingredients'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 72,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.no_photography_outlined,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Camera Unavailable',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'NauGiDay needs access to your camera to identify ingredients. Check your settings and try again.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                ref
                    .read(telemetryControllerProvider.notifier)
                    .recordCta('scan_retry');
                await _initCamera();
              },
              child: const Text('Retry Camera'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () async {
                ref
                    .read(telemetryControllerProvider.notifier)
                    .recordCta('open_settings');
                await ref
                    .read(scanPermissionRepositoryProvider)
                    .openSettings();
                await ref.read(scanControllerProvider.notifier).refreshPermissions();
              },
              child: const Text('Open Settings'),
            ),
            if (canUseGallery) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref
                    .read(scanControllerProvider.notifier)
                    .pickFromGallery(),
                child: const Text('Continue with gallery'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied(
    BuildContext context,
    PermissionState permissionState,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final canUseGallery = permissionState.photoStatus ==
            PermissionAccessStatus.granted ||
        permissionState.photoStatus == PermissionAccessStatus.limited;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ingredients'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 72,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.lock_outline,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Access is Off',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Enable camera access in Settings so we can scan your ingredients.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                ref
                    .read(telemetryControllerProvider.notifier)
                    .recordCta('open_settings');
                await ref
                    .read(scanPermissionRepositoryProvider)
                    .openSettings();
                await ref.read(scanControllerProvider.notifier).refreshPermissions();
              },
              child: const Text('Open Settings'),
            ),
            if (canUseGallery) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref
                    .read(scanControllerProvider.notifier)
                    .pickFromGallery(),
                child: const Text('Continue with gallery'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 72,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scanner is Taking a Break',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Our kitchen assistant is undergoing maintenance. You can still add ingredients manually or use your shopping list.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/ingredients/add'),
              child: const Text('Add Ingredients Manually'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/shopping-list'),
              child: const Text('Go to Shopping List'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalState(
    BuildContext context,
    ScanControllerState scanState,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final images = scanState.images;

    if (_controller == null || !_controller!.value.isInitialized) {
      return _buildInitializing(context);
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          _ScanOverlayFrame(colorScheme: colorScheme),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Scan Ingredients',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    ),
                    tooltip: _isFlashOn ? 'Flash on' : 'Flash off',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Point at ingredients to capture',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
          CameraControlsOverlay(
            onCapture: _takePicture,
            onPickGallery:
                () => ref.read(scanControllerProvider.notifier).pickFromGallery(),
            onHelp: _showHelpSheet,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ScanPreviewSheet(
              images: images,
              isOffline: scanState.isOffline,
              onGenerate: () => _generateRecipes(
                images.map((image) => image.path).toList(),
              ),
              onDelete: (id) =>
                  ref.read(scanControllerProvider.notifier).removeImage(id),
              onRetry: () =>
                  ref.read(scanControllerProvider.notifier).retryQueued(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanOverlayFrame extends StatelessWidget {
  const _ScanOverlayFrame({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.6),
            width: 2,
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onSurface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
