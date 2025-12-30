import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/presentation/providers/ingredient_bulk_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';

class IngredientBulkManageScreen extends ConsumerStatefulWidget {
  const IngredientBulkManageScreen({super.key});

  @override
  ConsumerState<IngredientBulkManageScreen> createState() =>
      _IngredientBulkManageScreenState();
}

class _IngredientBulkManageScreenState
    extends ConsumerState<IngredientBulkManageScreen> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ingredientsAsync = ref.watch(ingredientControllerProvider);
    final bulkState = ref.watch(ingredientBulkControllerProvider);
    final bulkController = ref.read(ingredientBulkControllerProvider.notifier);

    if (_quantityController.text != bulkState.quantityText) {
      _quantityController.text = bulkState.quantityText;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Manage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ingredientsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _ErrorState(
            onRetry: () =>
                ref.read(ingredientControllerProvider.notifier).refresh(),
          ),
          data: (ingredients) {
            if (ingredients.isEmpty) {
              return const _EmptyState();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected: ${bulkState.selectedIds.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                SegmentedButton<BulkQuantityMode>(
                  segments: const [
                    ButtonSegment(
                      value: BulkQuantityMode.none,
                      label: Text('No quantity change'),
                    ),
                    ButtonSegment(
                      value: BulkQuantityMode.set,
                      label: Text('Set quantity'),
                    ),
                    ButtonSegment(
                      value: BulkQuantityMode.adjust,
                      label: Text('Adjust +/-'),
                    ),
                  ],
                  selected: {bulkState.quantityMode},
                  onSelectionChanged: (value) => bulkController
                      .setQuantityMode(value.first),
                  showSelectedIcon: false,
                ),
                if (bulkState.quantityMode != BulkQuantityMode.none) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity value',
                    ),
                    onChanged: bulkController.setQuantityText,
                  ),
                  if (bulkState.quantityMode == BulkQuantityMode.adjust)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Use negative values to decrease quantities.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Builder(
                      builder: (context) {
                        final selected =
                            bulkState.inventoryState ==
                                IngredientInventoryState.used;
                        final labelColor = selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface;
                        return FilterChip(
                          label: const Text('Mark used'),
                          selected: selected,
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            color: labelColor,
                          ),
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: theme.colorScheme.primary,
                          checkmarkColor: labelColor,
                          showCheckmark: false,
                          side: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          onSelected: (selected) =>
                              bulkController.setInventoryState(
                            selected ? IngredientInventoryState.used : null,
                          ),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final selected =
                            bulkState.inventoryState ==
                                IngredientInventoryState.bought;
                        final labelColor = selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface;
                        return FilterChip(
                          label: const Text('Mark bought'),
                          selected: selected,
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            color: labelColor,
                          ),
                          backgroundColor: theme.colorScheme.surface,
                          selectedColor: theme.colorScheme.primary,
                          checkmarkColor: labelColor,
                          showCheckmark: false,
                          side: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          onSelected: (selected) =>
                              bulkController.setInventoryState(
                            selected ? IngredientInventoryState.bought : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                if (bulkState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      bulkState.error!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => _applyUpdate(context),
                      child: const Text('Apply update'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: bulkController.clearSelection,
                      child: const Text('Clear selection'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: ingredients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      final selected =
                          bulkState.selectedIds.contains(ingredient.id);
                      return Card(
                        child: CheckboxListTile(
                          value: selected,
                          onChanged: (_) =>
                              bulkController.toggleSelection(ingredient.id),
                          title: Text(ingredient.name),
                          subtitle: Text(
                            '${ingredient.quantity} ${ingredient.unit}',
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _applyUpdate(BuildContext context) async {
    final bulkController = ref.read(ingredientBulkControllerProvider.notifier);
    final update = bulkController.buildUpdate();
    if (update == null) return;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Apply bulk update'),
            content: Text(
              'Apply changes to ${update.ingredientIds.length} ingredients?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Apply'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await ref
        .read(ingredientControllerProvider.notifier)
        .applyBulkUpdate(update);
    bulkController.clearSelection();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bulk update applied')),
      );
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No ingredients available for bulk updates.'),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to load ingredients.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
