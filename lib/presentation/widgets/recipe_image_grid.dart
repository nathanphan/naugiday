import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';

class RecipeImageGrid extends StatelessWidget {
  final List<RecipeImage> images;
  final Future<void> Function() onAddImage;
  final void Function(int index) onRemove;

  const RecipeImageGrid({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Images',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: onAddImage,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add Image'),
            ),
          ],
        ),
        if (images.isEmpty)
          const Text('Attach photos to view offline.'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: images.asMap().entries.map((entry) {
            final idx = entry.key;
            final image = entry.value;
            return Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    image: File(image.localPath).existsSync()
                        ? DecorationImage(
                            image: FileImage(File(image.localPath)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !File(image.localPath).existsSync()
                      ? const Icon(Icons.image_not_supported)
                      : null,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close),
                    onPressed: () => onRemove(idx),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
