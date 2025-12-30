import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_form.dart';

class EditIngredientScreen extends ConsumerStatefulWidget {
  final String ingredientId;

  const EditIngredientScreen({
    super.key,
    required this.ingredientId,
  });

  @override
  ConsumerState<EditIngredientScreen> createState() =>
      _EditIngredientScreenState();
}

class _EditIngredientScreenState extends ConsumerState<EditIngredientScreen> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientControllerProvider);
    final formController = ref.read(ingredientFormControllerProvider.notifier);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Ingredient'),
        centerTitle: true,
      ),
      body: ingredientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _ErrorState(
          onRetry: () =>
              ref.read(ingredientControllerProvider.notifier).refresh(),
        ),
        data: (ingredients) {
          final ingredient = ingredients.firstWhere(
            (item) => item.id == widget.ingredientId,
            orElse: () => PantryIngredient(
              id: widget.ingredientId,
              name: '',
              categoryId: '',
              quantity: 0,
              unit: '',
              inventoryState: IngredientInventoryState.inStock,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          if (!_initialized && ingredient.name.isNotEmpty) {
            _initialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              formController.loadIngredient(ingredient);
            });
          }
          if (ingredient.name.isEmpty) {
            return _MissingState(onBack: () => context.go('/ingredients'));
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
            children: [
              const IngredientForm(),
            ],
          );
        },
      ),
      bottomNavigationBar: ingredientsAsync.maybeWhen(
        data: (ingredients) {
          final ingredient = ingredients.firstWhere(
            (item) => item.id == widget.ingredientId,
            orElse: () => PantryIngredient(
              id: widget.ingredientId,
              name: '',
              categoryId: '',
              quantity: 0,
              unit: '',
              inventoryState: IngredientInventoryState.inStock,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          if (ingredient.name.isEmpty) return null;
          return _SaveBar(
            label: 'Save changes',
            onPressed: () => _handleSave(
              context,
              ref,
              ingredient,
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    PantryIngredient ingredient,
  ) async {
    final formController = ref.read(ingredientFormControllerProvider.notifier);
    final ingredients = ref.read(ingredientControllerProvider).value ?? [];
    final now = DateTime.now();
    final validation = formController.validate(
      ingredientId: ingredient.id,
      createdAt: ingredient.createdAt,
      updatedAt: now,
      existing: ingredients,
    );
    if (!validation.isValid) {
      return;
    }
    if (validation.hasDuplicate) {
      final proceed = await _showDuplicateDialog(context);
      if (!proceed) return;
    }
    final updated = formController.buildIngredient(
      id: ingredient.id,
      createdAt: ingredient.createdAt,
      updatedAt: now,
      inventoryState: ingredient.inventoryState,
    );
    await ref.read(ingredientControllerProvider.notifier).updateIngredient(
          updated,
        );
    await ref.read(telemetryControllerProvider.notifier).recordCta(
          'ingredient_edit',
        );
    if (context.mounted) {
      context.go('/ingredients/${ingredient.id}');
    }
  }

  Future<bool> _showDuplicateDialog(BuildContext context) async {
    final decision = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Duplicate name'),
        content: const Text(
          'Another ingredient has the same name. Do you want to save anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save anyway'),
          ),
        ],
      ),
    );
    return decision ?? false;
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
            const Text('Unable to load ingredient.'),
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

class _MissingState extends StatelessWidget {
  final VoidCallback onBack;

  const _MissingState({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ingredient not found.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onBack,
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _SaveBar({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: SizedBox(
            height: 56,
            child: FilledButton.icon(
              icon: const Icon(Icons.check),
              label: Text(label),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
