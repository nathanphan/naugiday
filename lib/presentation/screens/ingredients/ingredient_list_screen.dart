import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/errors/ingredient_storage_exception.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_filters_provider.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_list_tile.dart';

class IngredientListScreen extends ConsumerStatefulWidget {
  const IngredientListScreen({super.key});

  @override
  ConsumerState<IngredientListScreen> createState() =>
      _IngredientListScreenState();
}

class _IngredientListScreenState extends ConsumerState<IngredientListScreen> {
  late final TextEditingController _searchController;
  bool _showAllExpiring = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PantryIngredient> _applyFilters(
    List<PantryIngredient> ingredients,
    IngredientFiltersState filters,
  ) {
    final query = filters.query.trim().toLowerCase();
    return ingredients.where((ingredient) {
      final matchesQuery = query.isEmpty ||
          ingredient.name.toLowerCase().contains(query) ||
          (ingredient.categoryName ?? '')
              .toLowerCase()
              .contains(query);
      final matchesCategory = filters.categoryIds.isEmpty ||
          filters.categoryIds.contains(ingredient.categoryId);
      return matchesQuery && matchesCategory;
    }).toList(growable: false);
  }

  List<PantryIngredient> _expiringSoon(List<PantryIngredient> items) {
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 3));
    return items
        .where(
          (ingredient) =>
              ingredient.expiryDate != null &&
              ingredient.expiryDate!.isAfter(now) &&
              ingredient.expiryDate!.isBefore(threshold),
        )
        .toList(growable: false);
  }

  List<PantryIngredient> _inStock(List<PantryIngredient> items) {
    return items
        .where((ingredient) =>
            ingredient.inventoryState == IngredientInventoryState.inStock)
        .toList(growable: false);
  }

  List<PantryIngredient> _outOfStock(List<PantryIngredient> items) {
    return items
        .where((ingredient) =>
            ingredient.inventoryState != IngredientInventoryState.inStock)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flagsAsync = ref.watch(featureFlagControllerProvider);
    final ingredientsAsync = ref.watch(ingredientControllerProvider);
    final filters = ref.watch(ingredientFiltersProvider);
    final categoriesAsync = ref.watch(ingredientCategoriesProvider);
    final ingredients = ingredientsAsync.value ?? const <PantryIngredient>[];
    final filtered = _applyFilters(ingredients, filters);
    final expiringSoon = _expiringSoon(filtered);
    final expiringPreview =
        _showAllExpiring ? expiringSoon : expiringSoon.take(2).toList();
    final inStock = _inStock(filtered)
        .where((item) => !expiringSoon.contains(item))
        .toList(growable: false);
    final outOfStock = _outOfStock(filtered);
    final hasFilters =
        filters.query.isNotEmpty || filters.categoryIds.isNotEmpty;

    if (_searchController.text != filters.query) {
      _searchController.text = filters.query;
    }

    final ingredientsEnabled =
        flagsAsync.value?.ingredientsEnabled ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ingredients'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Bulk manage',
            onPressed: ingredientsEnabled
                ? () => context.go('/ingredients/bulk')
                : null,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ingredientsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => _ErrorState(
                error: err,
                onRetry: () =>
                    ref.read(ingredientControllerProvider.notifier).refresh(),
                onRecover: () =>
                    ref.read(ingredientControllerProvider.notifier).recoverStorage(),
              ),
              data: (_) {
                if (!ingredientsEnabled) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Ingredient management is currently disabled.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                if (ingredients.isEmpty) {
                  return _EmptyState(
                    title: 'No ingredients yet',
                    message: 'Add ingredients to start managing your pantry.',
                    actionLabel: 'Add ingredient',
                    onAction: () => context.go('/ingredients/add'),
                  );
                }
                final noMatches = filtered.isEmpty;
                final bottomInset = kBottomNavigationBarHeight + 88;
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(ingredientControllerProvider.notifier).refresh(),
                  child: ListView(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    children: [
                      _SearchField(
                        controller: _searchController,
                        onChanged:
                            ref.read(ingredientFiltersProvider.notifier).setQuery,
                        onClear: () =>
                            ref.read(ingredientFiltersProvider.notifier).setQuery(''),
                      ),
                      const SizedBox(height: 12),
                      _CategoryFilters(
                        categoriesAsync: categoriesAsync,
                        filters: filters,
                      ),
                      if (hasFilters)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () =>
                                ref.read(ingredientFiltersProvider.notifier).clear(),
                            child: const Text('Clear filters'),
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (noMatches)
                        _EmptyState(
                          title: 'No matches',
                          message: 'Try a different search or clear your filters.',
                          actionLabel: 'Clear filters',
                          onAction: () => ref
                              .read(ingredientFiltersProvider.notifier)
                              .clear(),
                        ),
                      if (!noMatches) ...[
                      if (expiringPreview.isNotEmpty)
                        _SectionHeader(
                          title: 'Expiring soon',
                          actionLabel:
                              expiringSoon.length > expiringPreview.length
                                  ? 'View all'
                                  : null,
                          onAction: expiringSoon.length > expiringPreview.length
                              ? () {
                                  setState(() {
                                    _showAllExpiring = true;
                                  });
                                }
                              : null,
                        ),
                      if (expiringPreview.isNotEmpty)
                        ...expiringPreview.map(
                          (ingredient) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IngredientListTile(
                              ingredient: ingredient,
                              variant: IngredientCardVariant.expiringSoon,
                              onTap: () =>
                                  context.go('/ingredients/${ingredient.id}'),
                              onEdit: () =>
                                  context.go('/ingredients/${ingredient.id}/edit'),
                              onIncrement: () =>
                                  _adjustQuantity(ingredient, 1),
                              onDecrement: () =>
                                  _adjustQuantity(ingredient, -1),
                            ),
                          ),
                        ),
                      if (inStock.isNotEmpty) const SizedBox(height: 8),
                      if (inStock.isNotEmpty)
                        _SectionHeader(title: 'In stock'),
                      if (inStock.isNotEmpty)
                        ...inStock.map(
                          (ingredient) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IngredientListTile(
                              ingredient: ingredient,
                              variant: IngredientCardVariant.inStock,
                              onTap: () =>
                                  context.go('/ingredients/${ingredient.id}'),
                              onEdit: () =>
                                  context.go('/ingredients/${ingredient.id}/edit'),
                              onIncrement: () =>
                                  _adjustQuantity(ingredient, 1),
                              onDecrement: () =>
                                  _adjustQuantity(ingredient, -1),
                            ),
                          ),
                        ),
                      if (outOfStock.isNotEmpty) const SizedBox(height: 8),
                      if (outOfStock.isNotEmpty)
                        _SectionHeader(title: 'Out of stock'),
                      if (outOfStock.isNotEmpty)
                        ...outOfStock.map(
                          (ingredient) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: IngredientListTile(
                              ingredient: ingredient,
                              variant: IngredientCardVariant.outOfStock,
                              onTap: () =>
                                  context.go('/ingredients/${ingredient.id}'),
                              onRestock: () =>
                                  _markAsBought(ingredient),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (ingredientsEnabled)
            Positioned(
              left: 16,
              right: 16,
              bottom: kBottomNavigationBarHeight,
              child: SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.surface.withOpacity(0),
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add_circle),
                        label: const Text('Add Ingredient'),
                        onPressed: () => context.go('/ingredients/add'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _adjustQuantity(PantryIngredient ingredient, double delta) {
    final next = ingredient.quantity + delta;
    if (next <= 0) {
      return;
    }
    final updated = ingredient.copyWith(
      quantity: next,
      updatedAt: DateTime.now(),
    );
    ref.read(ingredientControllerProvider.notifier).updateIngredient(updated);
  }

  void _markAsBought(PantryIngredient ingredient) {
    final updated = ingredient.copyWith(
      inventoryState: IngredientInventoryState.bought,
      updatedAt: DateTime.now(),
    );
    ref.read(ingredientControllerProvider.notifier).updateIngredient(updated);
  }
}

class _CategoryFilters extends ConsumerWidget {
  final AsyncValue<List<IngredientCategory>> categoriesAsync;
  final IngredientFiltersState filters;

  const _CategoryFilters({
    required this.categoriesAsync,
    required this.filters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return categoriesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => Text(
        'Unable to load categories',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }
        final ordered = _orderCategories(categories);
        final isAllSelected = filters.categoryIds.isEmpty;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                selected: isAllSelected,
                selectedColor: theme.colorScheme.primary,
                onSelected: () => ref
                    .read(ingredientFiltersProvider.notifier)
                    .clearCategories(),
              ),
              for (final category in ordered)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _FilterChip(
                    label: category.name,
                    selected: filters.categoryIds.contains(category.id),
                    selectedColor: theme.colorScheme.primary,
                    onSelected: () => ref
                        .read(ingredientFiltersProvider.notifier)
                        .toggleCategory(category.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<IngredientCategory> _orderCategories(
    List<IngredientCategory> categories,
  ) {
    const priority = {
      'fridge': 0,
      'pantry': 1,
      'freezer': 2,
    };
    final ordered = [...categories];
    ordered.sort((a, b) {
      final aKey = priority[a.name.toLowerCase()] ?? 100;
      final bKey = priority[b.name.toLowerCase()] ?? 100;
      if (aKey != bKey) {
        return aKey.compareTo(bKey);
      }
      return a.name.compareTo(b.name);
    });
    return ordered;
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search your ingredients...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.cancel),
                onPressed: onClear,
              ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;
    return FilterChip(
      label: Text(label),
      selected: selected,
      labelStyle: theme.textTheme.labelLarge?.copyWith(color: labelColor),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: selectedColor,
      checkmarkColor: labelColor,
      showCheckmark: false,
      side: BorderSide(color: theme.colorScheme.outlineVariant),
      onSelected: (_) => onSelected(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final VoidCallback onRecover;

  const _ErrorState({
    required this.error,
    required this.onRetry,
    required this.onRecover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRecoverable = error is IngredientStorageException;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'We could not load ingredients.',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
                if (isRecoverable)
                  FilledButton.tonal(
                    onPressed: onRecover,
                    child: const Text('Recover'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
