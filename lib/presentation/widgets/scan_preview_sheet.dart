import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/scan_image.dart';

class ScanPreviewSheet extends StatelessWidget {
  const ScanPreviewSheet({
    super.key,
    required this.images,
    required this.onGenerate,
    required this.onDelete,
    required this.isOffline,
    required this.onRetry,
  });

  final List<ScanImage> images;
  final VoidCallback onGenerate;
  final void Function(String id) onDelete;
  final bool isOffline;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Scanned items',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${images.length}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final image = images[index];
                return _ScanThumbnail(
                  image: image,
                  onDelete: () => onDelete(image.id),
                );
              },
            ),
          ),
          if (isOffline) ...[
            const SizedBox(height: 12),
            Text(
              'Saved offline. We will process when you are back online.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (_hasRetryable(images)) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onRetry,
                child: const Text('Retry processing'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: isOffline ? null : onGenerate,
            icon: Icon(isOffline ? Icons.cloud_upload : Icons.auto_awesome),
            label: Text(
              isOffline
                  ? 'Queued for processing'
                  : 'Generate Recipes (${images.length})',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanThumbnail extends StatelessWidget {
  const _ScanThumbnail({
    required this.image,
    required this.onDelete,
  });

  final ScanImage image;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusIcon = _statusIcon(colorScheme);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(image.path),
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 72,
                height: 72,
                color: colorScheme.surfaceVariant,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              );
            },
          ),
        ),
        if (statusIcon != null)
          Positioned(
            bottom: -4,
            right: -4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.12),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  statusIcon.icon,
                  size: 14,
                  color: statusIcon.color,
                ),
              ),
            ),
          ),
        Positioned(
          top: -6,
          right: -6,
          child: Semantics(
            label: 'Remove image',
            button: true,
            child: IconButton.filled(
              onPressed: onDelete,
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }

  _StatusIcon? _statusIcon(ColorScheme colorScheme) {
    switch (image.status) {
      case ScanImageStatus.queued:
        return _StatusIcon(Icons.cloud_upload, colorScheme.primary);
      case ScanImageStatus.failed:
        return _StatusIcon(Icons.error_outline, colorScheme.error);
      case ScanImageStatus.processing:
        return _StatusIcon(Icons.sync, colorScheme.secondary);
      case ScanImageStatus.processed:
        return null;
    }
  }
}

class _StatusIcon {
  _StatusIcon(this.icon, this.color);

  final IconData icon;
  final Color color;
}

bool _hasRetryable(List<ScanImage> images) {
  return images.any(
    (image) =>
        image.status == ScanImageStatus.queued ||
        image.status == ScanImageStatus.failed,
  );
}
// ignore_for_file: deprecated_member_use, unnecessary_underscores
