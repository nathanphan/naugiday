import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/errors/ingredient_storage_exception.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_repository_provider.dart';
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
    final canProceed =
        await _resolveMissingPhotos(context, ref, formController, formState);
    if (!canProceed) {
      return;
    }
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
    try {
      await ref.read(ingredientControllerProvider.notifier).addIngredient(
            ingredient,
          );
    } on IngredientStorageException catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      }
      return;
    }
    await ref.read(telemetryControllerProvider.notifier).recordCta(
          'ingredient_add',
        );
    if (context.mounted) {
      context.go('/ingredients');
    }
  }

  Future<bool> _resolveMissingPhotos(
    BuildContext context,
    WidgetRef ref,
    IngredientFormController formController,
    IngredientFormState formState,
  ) async {
    if (formState.photos.isEmpty) return true;
    final storage = ref.read(ingredientPhotoStorageProvider);
    final missing = <String>[];
    for (final photo in formState.photos) {
      if (photo.path.trim().isEmpty) {
        missing.add(photo.id);
        continue;
      }
      final exists = await storage.exists(photo.path);
      if (!exists) {
        missing.add(photo.id);
      }
    }
    if (missing.isEmpty) return true;
    final remove = await _showMissingPhotosDialog(context, missing.length);
    if (!remove) return false;
    for (final id in missing) {
      formController.removePhoto(id);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing photos removed.')),
      );
    }
    return false;
  }

  Future<bool> _showMissingPhotosDialog(
    BuildContext context,
    int missingCount,
  ) async {
    final decision = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Missing photos'),
        content: Text(
          '$missingCount photo(s) can\'t be found. Remove them or reselect.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove missing'),
          ),
        ],
      ),
    );
    return decision ?? false;
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
