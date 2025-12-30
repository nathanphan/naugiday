import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';

class IngredientPhotoViewer extends StatefulWidget {
  final List<IngredientPhoto> photos;
  final int initialIndex;

  const IngredientPhotoViewer({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  static Future<void> show(
    BuildContext context, {
    required List<IngredientPhoto> photos,
    String? initialPhotoId,
  }) async {
    if (photos.isEmpty) return;
    final initialIndex = initialPhotoId == null
        ? 0
        : photos.indexWhere((photo) => photo.id == initialPhotoId);
    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        child: IngredientPhotoViewer(
          photos: photos,
          initialIndex: initialIndex < 0 ? 0 : initialIndex,
        ),
      ),
    );
  }

  @override
  State<IngredientPhotoViewer> createState() => _IngredientPhotoViewerState();
}

class _IngredientPhotoViewerState extends State<IngredientPhotoViewer> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo ${_currentIndex + 1} of ${widget.photos.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.photos.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final photo = widget.photos[index];
          return Semantics(
            label: 'Ingredient photo ${index + 1}',
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Photo unavailable',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
