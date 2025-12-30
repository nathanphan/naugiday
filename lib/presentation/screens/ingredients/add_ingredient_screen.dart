import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_form.dart';
import 'package:uuid/uuid.dart';

class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() =>
      _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ingredientFormControllerProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientControllerProvider);
    final formController = ref.read(ingredientFormControllerProvider.notifier);
    final formState = ref.watch(ingredientFormControllerProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ingredient'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
        children: [
          if (ingredientsAsync.isLoading)
            const LinearProgressIndicator(),
          if (ingredientsAsync.hasError)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: const Text('Unable to load ingredients'),
                  subtitle: Text(ingredientsAsync.error.toString()),
                  trailing: TextButton(
                    onPressed: () => ref
                        .read(ingredientControllerProvider.notifier)
                        .refresh(),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            ),
          const IngredientForm(),
        ],
      ),
      bottomNavigationBar: _SaveBar(
        label: 'Save Ingredient',
        onPressed: ingredientsAsync.isLoading
            ? null
            : () => _handleSave(context, ref, formController, formState),
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    IngredientFormController formController,
    IngredientFormState formState,
  ) async {
    final ingredients = ref.read(ingredientControllerProvider).value ?? [];
    final now = DateTime.now();
    final id = const Uuid().v4();
    final validation = formController.validate(
      ingredientId: id,
      createdAt: now,
      updatedAt: now,
      existing: ingredients,
    );
    if (!validation.isValid) {
      return;
    }
    if (validation.hasDuplicate) {
      final decision = await _showDuplicateDialog(context);
      if (decision == DuplicateDecision.editExisting) {
        final match = ingredients.firstWhere(
          (item) =>
              item.name.trim().toLowerCase() ==
              formState.name.trim().toLowerCase(),
          orElse: () => ingredients.first,
        );
        if (context.mounted) {
          context.go('/ingredients/${match.id}/edit');
        }
        return;
      }
      if (decision == DuplicateDecision.cancel) {
        return;
      }
    }
    final ingredient = formController.buildIngredient(
      id: id,
      createdAt: now,
      updatedAt: now,
      inventoryState: IngredientInventoryState.inStock,
    );
    await ref.read(ingredientControllerProvider.notifier).addIngredient(
          ingredient,
        );
    await ref.read(telemetryControllerProvider.notifier).recordCta(
          'ingredient_add',
        );
    if (context.mounted) {
      context.go('/ingredients');
    }
  }

  Future<DuplicateDecision> _showDuplicateDialog(BuildContext context) async {
    final decision = await showDialog<DuplicateDecision>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Duplicate name'),
        content: const Text(
          'An ingredient with this name already exists. '
          'Do you want to edit the existing item instead?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(DuplicateDecision.cancel),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () =>
                Navigator.of(ctx).pop(DuplicateDecision.keepBoth),
            child: const Text('Add anyway'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(ctx).pop(DuplicateDecision.editExisting),
            child: const Text('Edit existing'),
          ),
        ],
      ),
    );
    return decision ?? DuplicateDecision.cancel;
  }
}

enum DuplicateDecision { cancel, keepBoth, editExisting }

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
