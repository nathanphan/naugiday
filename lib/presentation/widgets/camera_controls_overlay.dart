import 'package:flutter/material.dart';

class CameraControlsOverlay extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onToggleFlash;
  final VoidCallback onPickGallery;
  final bool isFlashOn;

  const CameraControlsOverlay({
    super.key,
    required this.onCapture,
    required this.onToggleFlash,
    required this.onPickGallery,
    required this.isFlashOn,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Flash Toggle
            IconButton.filledTonal(
              onPressed: onToggleFlash,
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
            ),

            // Shutter Button
            GestureDetector(
              onTap: onCapture,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: Colors.transparent,
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Gallery Picker
            IconButton.filledTonal(
              onPressed: onPickGallery,
              icon: const Icon(Icons.photo_library),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
