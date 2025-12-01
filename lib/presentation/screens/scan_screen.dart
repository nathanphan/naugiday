import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final List<XFile> _capturedImages = [];
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(_cameras![0], ResolutionPreset.medium);
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
      } else {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      setState(() => _isInitializing = false);
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

  void _generateRecipes() {
    final mealType = GoRouterState.of(context).extra as MealType? ?? MealType.dinner;
    
    context.go('/suggestions', extra: {
      'images': _capturedImages.map((e) => e.path).toList(),
      'mealType': mealType,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: Text('Camera not available')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Ingredients')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _capturedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(File(_capturedImages[index].path)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera),
                ),
                if (_capturedImages.isNotEmpty)
                  FilledButton(
                    onPressed: _generateRecipes,
                    child: const Text('Generate Recipes'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
