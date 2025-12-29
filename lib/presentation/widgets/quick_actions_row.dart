import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';

class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionItem(
          context,
          icon: Icons.receipt_long_rounded,
          label: 'My Recipes',
          onTap: () {
            ref
                .read(telemetryControllerProvider.notifier)
                .recordScreenView('my-recipes');
            context.go('/my-recipes');
          },
        ),
        _buildActionItem(
          context,
          icon: Icons.shopping_cart_rounded,
          label: 'Shopping',
          onTap: () {
            ref
                .read(telemetryControllerProvider.notifier)
                .recordScreenView('shopping-list');
            context.go('/shopping-list');
          },
        ),
        _buildActionItem(
          context,
          icon: Icons.bookmark_rounded,
          label: 'Saved',
          onTap: () {}, // TODO: Implement Saved
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 72,
            height: 96,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(icon, color: theme.colorScheme.onSecondaryContainer),
                ),
                const SizedBox(height: 8),
                Text(label, style: theme.textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
