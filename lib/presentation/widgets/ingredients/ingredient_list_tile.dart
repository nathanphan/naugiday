import 'package:flutter/material.dart';
import 'package:naugiday/core/constants/app_assets.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';

enum IngredientCardVariant { expiringSoon, inStock, outOfStock }

class IngredientListTile extends StatelessWidget {
  final PantryIngredient ingredient;
  final IngredientCardVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRestock;

  const IngredientListTile({
    super.key,
    required this.ingredient,
    required this.variant,
    this.onTap,
    this.onEdit,
    this.onIncrement,
    this.onDecrement,
    this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _accentColor(colorScheme);
    final showAccent = variant == IngredientCardVariant.expiringSoon;
    final showStepper = onIncrement != null || onDecrement != null;
    final showRestock =
        variant == IngredientCardVariant.outOfStock && onRestock != null;
    final quantityLabel = _formatQuantity(ingredient.quantity, ingredient.unit);
    final expiryDate = ingredient.expiryDate;

    return Semantics(
      button: onTap != null,
      label: 'Ingredient ${ingredient.name}',
      child: Card(
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showAccent)
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _IngredientImage(
                            expiryDate: expiryDate,
                            accentColor: accentColor,
                            showBadge: showAccent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _IngredientInfo(
                              ingredient: ingredient,
                              variant: variant,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (showRestock)
                            FilledButton.tonal(
                              onPressed: onRestock,
                              child: const Text('Restock'),
                            )
                          else if (showStepper)
                            _QuantityStepper(
                              quantityLabel: quantityLabel,
                              onIncrement: onIncrement,
                              onDecrement: onDecrement,
                            )
                          else
                            _QuantitySummary(
                              quantityLabel: quantityLabel,
                              onEdit: onEdit,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(ColorScheme colorScheme) {
    if (variant != IngredientCardVariant.expiringSoon) {
      return colorScheme.outlineVariant;
    }
    final expiryDate = ingredient.expiryDate;
    if (expiryDate == null) return colorScheme.primary;
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days <= 2) return colorScheme.error;
    if (days <= 5) return colorScheme.tertiary;
    return colorScheme.primary;
  }

  String _formatQuantity(double quantity, String unit) {
    final normalized = quantity % 1 == 0
        ? quantity.toStringAsFixed(0)
        : quantity.toStringAsFixed(1);
    if (unit.trim().isEmpty) {
      return normalized;
    }
    return '$normalized $unit';
  }
}

class _IngredientImage extends StatelessWidget {
  final DateTime? expiryDate;
  final Color accentColor;
  final bool showBadge;

  const _IngredientImage({
    required this.expiryDate,
    required this.accentColor,
    required this.showBadge,
  });

  @override
  Widget build(BuildContext context) {
    final badge = _ExpiryBadge.fromDate(
      expiryDate: expiryDate,
      colorScheme: Theme.of(context).colorScheme,
      accentColor: accentColor,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            AppAssets.foodPlaceholder,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        if (showBadge && badge != null)
          Positioned(
            right: -4,
            bottom: -4,
            child: badge,
          ),
      ],
    );
  }
}

class _IngredientInfo extends StatelessWidget {
  final PantryIngredient ingredient;
  final IngredientCardVariant variant;

  const _IngredientInfo({
    required this.ingredient,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final createdLabel = _formatDate(context, ingredient.createdAt);
    final expiryDate = ingredient.expiryDate;
    final expiryLabel =
        expiryDate == null ? null : _formatDate(context, expiryDate);
    final categoryLabel = ingredient.categoryName ?? 'Uncategorized';
    final tagBackground = colorScheme.surfaceContainerHighest;
    final expiryColors = _ExpiryTagColors.fromVariant(
      variant,
      colorScheme,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          categoryLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _InfoTag(
              icon: Icons.shopping_bag,
              label: 'Buy: $createdLabel',
              background: tagBackground,
              foreground: colorScheme.onSurfaceVariant,
            ),
            if (expiryLabel != null)
              _InfoTag(
                icon: variant == IngredientCardVariant.expiringSoon
                    ? Icons.event_busy
                    : Icons.event,
                label: 'Exp: $expiryLabel',
                background: expiryColors.background,
                foreground: expiryColors.foreground,
                border: expiryColors.border,
              ),
          ],
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final Color? border;

  const _InfoTag({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final String quantityLabel;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const _QuantityStepper({
    required this.quantityLabel,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            tooltip: 'Decrease quantity',
            onPressed: onDecrement,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantityLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            tooltip: 'Increase quantity',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 18, color: colorScheme.primary),
      onPressed: onPressed,
    );
  }
}

class _QuantitySummary extends StatelessWidget {
  final String quantityLabel;
  final VoidCallback? onEdit;

  const _QuantitySummary({
    required this.quantityLabel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          quantityLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (onEdit != null)
          TextButton(
            onPressed: onEdit,
            child: const Text('Edit'),
          ),
      ],
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final Color border;

  const _ExpiryBadge({
    required this.label,
    required this.background,
    required this.foreground,
    required this.border,
  });

  static _ExpiryBadge? fromDate({
    required DateTime? expiryDate,
    required ColorScheme colorScheme,
    required Color accentColor,
  }) {
    if (expiryDate == null) return null;
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) return null;
    final label = '${days}d';
    final colors = _ExpiryBadgeColors.fromAccent(
      accentColor,
      colorScheme,
    );
    return _ExpiryBadge(
      label: label,
      background: colors.background,
      foreground: colors.foreground,
      border: colors.border,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ExpiryBadgeColors {
  final Color background;
  final Color foreground;
  final Color border;

  const _ExpiryBadgeColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  static _ExpiryBadgeColors fromAccent(
    Color accentColor,
    ColorScheme colorScheme,
  ) {
    if (accentColor == colorScheme.error) {
      return _ExpiryBadgeColors(
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
        border: colorScheme.error.withOpacity(0.4),
      );
    }
    if (accentColor == colorScheme.tertiary) {
      return _ExpiryBadgeColors(
        background: colorScheme.tertiaryContainer,
        foreground: colorScheme.onTertiaryContainer,
        border: colorScheme.tertiary.withOpacity(0.4),
      );
    }
    return _ExpiryBadgeColors(
      background: colorScheme.primaryContainer,
      foreground: colorScheme.onPrimaryContainer,
      border: colorScheme.primary.withOpacity(0.4),
    );
  }
}

class _ExpiryTagColors {
  final Color background;
  final Color foreground;
  final Color? border;

  const _ExpiryTagColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  static _ExpiryTagColors fromVariant(
    IngredientCardVariant variant,
    ColorScheme colorScheme,
  ) {
    if (variant == IngredientCardVariant.expiringSoon) {
      return _ExpiryTagColors(
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
        border: colorScheme.error.withOpacity(0.3),
      );
    }
    return _ExpiryTagColors(
      background: colorScheme.surfaceContainerHighest,
      foreground: colorScheme.onSurfaceVariant,
    );
  }
}
