import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/core/constants/app_assets.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/errors/ingredient_storage_exception.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';

class IngredientDetailScreen extends ConsumerWidget {
  final String ingredientId;

  const IngredientDetailScreen({
    super.key,
    required this.ingredientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsAsync = ref.watch(ingredientControllerProvider);
    final controller = ref.read(ingredientControllerProvider.notifier);
    final recipesAsync = ref.watch(recipeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          PopupMenuButton<_DetailAction>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == _DetailAction.edit) {
                context.go('/ingredients/$ingredientId/edit');
              } else {
                _confirmDelete(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _DetailAction.edit,
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: _DetailAction.delete,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: ingredientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorState(
          message: 'Unable to load ingredient.',
          onRetry: controller.refresh,
          onRecover:
              err is IngredientStorageException ? controller.recoverStorage : null,
        ),
        data: (ingredients) {
          final ingredient = ingredients
              .where((item) => item.id == ingredientId)
              .cast<PantryIngredient?>()
              .firstWhere((item) => item != null, orElse: () => null);
          if (ingredient == null) {
            return _ErrorState(
              message: 'Ingredient not found.',
              onRetry: controller.refresh,
            );
          }
          final recipeSuggestions = _filterSuggestions(
            recipesAsync.value ?? const <Recipe>[],
            ingredient,
          );
          final bottomPadding = MediaQuery.of(context).padding.bottom + 96;
          return ListView(
            padding: EdgeInsets.only(bottom: bottomPadding),
            children: [
              _HeaderSection(ingredient: ingredient),
              _SuggestedRecipesSection(
                recipesAsync: recipesAsync,
                suggestions: recipeSuggestions,
                onRefresh: () =>
                    ref.read(recipeControllerProvider.notifier).refresh(),
                onOpenRecipe: (recipe) => _openRecipe(context, recipe),
              ),
              const SizedBox(height: 12),
              _DetailsSection(ingredient: ingredient),
              const SizedBox(height: 16),
              const _NotesSection(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/ingredients/$ingredientId/edit'),
        icon: const Icon(Icons.edit),
        label: const Text('Edit Details'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _openRecipe(BuildContext context, Recipe recipe) {
    context.go(
      '/recipe-detail',
      extra: {'recipe': recipe, 'detected': const <String>[]},
    );
  }

  List<Recipe> _filterSuggestions(
    List<Recipe> recipes,
    PantryIngredient ingredient,
  ) {
    final query = ingredient.name.toLowerCase();
    return recipes
        .where(
          (recipe) => recipe.ingredients.any(
            (item) => item.name.toLowerCase().contains(query),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(ingredientControllerProvider.notifier);
    final telemetry = ref.read(telemetryControllerProvider.notifier);
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete ingredient'),
            content: const Text(
              'This action cannot be undone. Do you want to delete it?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await controller.deleteIngredient(ingredientId);
    await telemetry.recordCta('ingredient_delete');
    if (context.mounted) {
      context.go('/ingredients');
    }
  }
}

enum _DetailAction { edit, delete }

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onRecover;

  const _ErrorState({
    required this.message,
    required this.onRetry,
    this.onRecover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
                if (onRecover != null)
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

class _HeaderSection extends StatelessWidget {
  final PantryIngredient ingredient;

  const _HeaderSection({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expiryChip = _ExpiryChip.fromIngredient(
      ingredient,
      colorScheme: colorScheme,
    );
    final categoryLabel = ingredient.categoryName ?? 'Uncategorized';
    final stateLabel = _stateLabel(ingredient.inventoryState);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.25),
            colorScheme.surface.withOpacity(0),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: colorScheme.surface,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage(
                      AppAssets.foodPlaceholder,
                    ),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    Icons.local_florist,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ingredient.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$categoryLabel \u2022 $stateLabel',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (expiryChip != null) ...[
            const SizedBox(height: 12),
            expiryChip,
          ],
        ],
      ),
    );
  }

  String _stateLabel(IngredientInventoryState state) {
    switch (state) {
      case IngredientInventoryState.inStock:
        return 'Pantry Item';
      case IngredientInventoryState.used:
        return 'Used';
      case IngredientInventoryState.bought:
        return 'Bought';
    }
  }
}

class _ExpiryChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  const _ExpiryChip({
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  static _ExpiryChip? fromIngredient(
    PantryIngredient ingredient, {
    required ColorScheme colorScheme,
  }) {
    final expiryDate = ingredient.expiryDate;
    if (expiryDate == null) return null;
    final now = DateTime.now();
    final diff = expiryDate.difference(now).inDays;
    if (diff < 0) {
      return _ExpiryChip(
        label: 'Expired',
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
        icon: Icons.event_busy,
      );
    }
    if (diff == 0) {
      return _ExpiryChip(
        label: 'Expiring today',
        background: colorScheme.tertiaryContainer,
        foreground: colorScheme.onTertiaryContainer,
        icon: Icons.schedule,
      );
    }
    return _ExpiryChip(
      label: 'Expiring in $diff days',
      background: colorScheme.tertiaryContainer,
      foreground: colorScheme.onTertiaryContainer,
      icon: Icons.history_toggle_off,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedRecipesSection extends StatelessWidget {
  final AsyncValue<List<Recipe>> recipesAsync;
  final List<Recipe> suggestions;
  final VoidCallback onRefresh;
  final ValueChanged<Recipe> onOpenRecipe;

  const _SuggestedRecipesSection({
    required this.recipesAsync,
    required this.suggestions,
    required this.onRefresh,
    required this.onOpenRecipe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI-Suggested Recipes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 236,
          child: recipesAsync.when(
            loading: () => Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            ),
            error: (_, __) => _SuggestionEmpty(
              message: 'Unable to load recipes.',
              icon: Icons.error_outline,
            ),
            data: (_) {
              if (suggestions.isEmpty) {
                return const _SuggestionEmpty(
                  message: 'No suggestions yet.',
                  icon: Icons.auto_awesome_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final recipe = suggestions[index];
                  return _RecipeSuggestionCard(
                    recipe: recipe,
                    onPrimary: () => onOpenRecipe(recipe),
                    onSecondary: () => onOpenRecipe(recipe),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecipeSuggestionCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _RecipeSuggestionCard({
    required this.recipe,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      width: 240,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                AppAssets.foodPlaceholder,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.description.isEmpty
                          ? 'Quick & flavorful, perfect for tonight.'
                          : recipe.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: onPrimary,
                            child: const Text('Cook This'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onSecondary,
                            child: const Text('View Recipe'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionEmpty extends StatelessWidget {
  final String message;
  final IconData icon;

  const _SuggestionEmpty({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final PantryIngredient ingredient;

  const _DetailsSection({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final quantityLabel = _formatQuantity(
      ingredient.quantity,
      ingredient.unit,
    );
    final locationLabel = ingredient.categoryName ?? 'Uncategorized';
    final purchasedLabel = _formatDate(context, ingredient.createdAt);
    final expiryLabel = ingredient.expiryDate == null
        ? 'Not set'
        : _formatDate(context, ingredient.expiryDate!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Ingredient Details',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _DetailTile(
                label: 'Quantity',
                value: quantityLabel,
                icon: Icons.scale,
              ),
              _DetailTile(
                label: 'Location',
                value: locationLabel,
                icon: Icons.kitchen,
              ),
              _DetailTile(
                label: 'Purchased',
                value: purchasedLabel,
                icon: Icons.shopping_bag,
              ),
              _DetailTile(
                label: 'Expires',
                value: expiryLabel,
                icon: Icons.event_busy,
                accent: expiryLabel == 'Not set'
                    ? null
                    : colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
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

  String _formatDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  const _DetailTile({
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = accent ?? colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: accentColor),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent != null ? accentColor : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.edit_note,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Add a note about how you like to use this ingredient.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
