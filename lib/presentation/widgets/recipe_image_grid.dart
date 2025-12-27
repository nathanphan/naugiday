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
            final file = File(image.localPath);
            final hasFile = file.existsSync();
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey.shade200,
                    child: hasFile
                        ? Image.file(
                            file,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Center(child: Icon(Icons.image_not_supported)),
                  ),
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
