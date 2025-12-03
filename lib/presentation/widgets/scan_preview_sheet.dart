import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanPreviewSheet extends StatefulWidget {
  final List<XFile> images;
  final void Function(List<String> labels) onGenerate;
  final Function(int) onDelete;

  const ScanPreviewSheet({
    super.key,
    required this.images,
    required this.onGenerate,
    required this.onDelete,
  });

  @override
  State<ScanPreviewSheet> createState() => _ScanPreviewSheetState();
}

class _ScanPreviewSheetState extends State<ScanPreviewSheet> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.images.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void didUpdateWidget(covariant ScanPreviewSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images.length != widget.images.length) {
      _controllers = List.generate(
        widget.images.length,
        (i) => TextEditingController(
          text: i < oldWidget.images.length ? _controllers[i].text : '',
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.images.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${widget.images.length} Ingredients Scanned',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.images[index].path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => widget.onDelete(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _controllers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _controllers[index],
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      isDense: true,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              final labels = _controllers.map((c) => c.text).toList();
              widget.onGenerate(labels);
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Generate Recipes'),
          ),
        ],
      ),
    );
  }
}
