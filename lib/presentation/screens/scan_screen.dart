import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/presentation/widgets/camera_controls_overlay.dart';
import 'package:naugiday/presentation/widgets/scan_preview_sheet.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';
import 'package:naugiday/presentation/widgets/skeletons.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, this.forceCameraUnavailable = false});

  final bool forceCameraUnavailable;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final List<XFile> _capturedImages = [];
  List<String> _labels = [];
  bool _isInitializing = true;
  bool _isFlashOn = false;
  bool _cameraUnavailable = false;

  @override
  void initState() {
    super.initState();
    if (widget.forceCameraUnavailable) {
      _cameraUnavailable = true;
      _isInitializing = false;
    } else {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      if (DebugToggles.cameraMode == CameraDebugMode.unavailable) {
        setState(() {
          _isInitializing = false;
          _cameraUnavailable = true;
        });
        return;
      }
      if (DebugToggles.cameraMode == CameraDebugMode.slow) {
        await Future.delayed(const Duration(seconds: 2));
      }
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      } else {
        setState(() {
          _isInitializing = false;
          _cameraUnavailable = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      setState(() {
        _isInitializing = false;
        _cameraUnavailable = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImages.add(image);
      });
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _toggleFlash() {
    if (_controller == null) return;
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  void _pickGallery() {
    // TODO: Implement gallery picker
  }

  void _generateRecipes() {
    final mealType =
        GoRouterState.of(context).extra as MealType? ?? MealType.dinner;

    context.go(
      '/suggestions',
      extra: {
        'images': _capturedImages.map((e) => e.path).toList(),
        'labels': _labels,
        'mealType': mealType,
      },
    );
  }

  void _deleteImage(int index) {
    setState(() {
      _capturedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: SkeletonBlock(height: 120, shimmer: true)),
      );
    }

    if (_cameraUnavailable || _controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black87,
                    Colors.black54,
                    Colors.black87,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, color: Colors.white, size: 48),
                    const SizedBox(height: AppTheme.spacingM),
                    const Text(
                      'Camera not available',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    const Text(
                      'Check permissions or try again.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _initCamera,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Retry', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        OutlinedButton.icon(
                          onPressed: () => openAppSettings(context),
                          icon: const Icon(Icons.settings, color: Colors.white),
                          label: const Text('Settings', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          CameraPreview(_controller!),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),

          // Controls Overlay (visible only if no images captured or sheet not fully expanded)
          if (_capturedImages.isEmpty)
            CameraControlsOverlay(
              onCapture: _takePicture,
              onToggleFlash: _toggleFlash,
              onPickGallery: _pickGallery,
              isFlashOn: _isFlashOn,
            ),

          // If images captured, show mini controls + sheet
          if (_capturedImages.isNotEmpty) ...[
            Positioned(
              bottom: 200, // Above the sheet
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: Colors.transparent,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ScanPreviewSheet(
                images: _capturedImages,
                onGenerate: (labels) {
                  _labels = labels;
                  _generateRecipes();
                },
                onDelete: _deleteImage,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void openAppSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open settings to allow camera access.')),
    );
  }
}
