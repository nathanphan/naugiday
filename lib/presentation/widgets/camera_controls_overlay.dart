import 'package:flutter/material.dart';

class CameraControlsOverlay extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onPickGallery;
  final VoidCallback onHelp;

  const CameraControlsOverlay({
    super.key,
    required this.onCapture,
    required this.onPickGallery,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28, left: 24, right: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.filledTonal(
              onPressed: onPickGallery,
              icon: const Icon(Icons.photo_library_outlined),
              tooltip: 'Choose from photos',
            ),

            Semantics(
              label: 'Capture photo',
              button: true,
              child: GestureDetector(
                onTap: onCapture,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.onSurface, width: 4),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),

            IconButton.filledTonal(
              onPressed: onHelp,
              icon: const Icon(Icons.help_outline),
              tooltip: 'Help',
            ),
          ],
        ),
      ),
    );
  }
}
