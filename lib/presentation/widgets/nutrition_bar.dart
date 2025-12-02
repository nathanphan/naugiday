import 'package:flutter/material.dart';

class NutritionBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color? color;

  const NutritionBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(
              '$value${_getUnit()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              color ?? theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  String _getUnit() {
    if (label.toLowerCase().contains('calor')) return ' kcal';
    return 'g';
  }
}
