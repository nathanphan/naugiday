import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/add_recipe_controller.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/telemetry_provider.dart';
import 'package:naugiday/presentation/widgets/ingredient_list.dart';
import 'package:naugiday/presentation/widgets/recipe_image_grid.dart';
import 'package:naugiday/presentation/widgets/steps_list.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  final Recipe? initialRecipe;

  const CreateRecipeScreen({super.key, this.initialRecipe});

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  MealType _mealType = MealType.dinner;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRecipe;
    if (initial != null) {
      _nameController.text = initial.name;
      _descController.text = initial.description;
      _mealType = initial.mealType;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addRecipeControllerProvider.notifier).loadFromRecipe(initial);
      });
    }
  }

  void _navigateBack() {
    final router = GoRouter.of(context);
    if (widget.initialRecipe == null) {
      router.go('/my-recipes');
      return;
    }
    if (router.canPop()) {
      router.pop();
    } else {
      router.go('/my-recipes');
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the required fields.')),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final addNotifier = ref.read(addRecipeControllerProvider.notifier);
    ref.read(telemetryControllerProvider.notifier).recordCta('save_recipe');
    addNotifier.setTitle(_nameController.text);
    addNotifier.setDescription(_descController.text);
    addNotifier.setMealType(_mealType);
    final addState = ref.read(addRecipeControllerProvider);
    final missingErrors = <String>[];
    if (addState.ingredients.isEmpty) {
      missingErrors.add('At least one ingredient is required');
    }
    if (addState.steps.isEmpty) {
      missingErrors.add('At least one cooking step is required');
    }
    if (missingErrors.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(missingErrors.join(', '))),
      );
      return;
    }
    final validation = addNotifier.validate();
    if (!validation.isValid) {
      messenger.showSnackBar(
        SnackBar(content: Text(validation.errors.join(', '))),
      );
      return;
    }
    final success = await addNotifier.save();
    if (!mounted) return;
    if (success) {
      await ref.read(recipeControllerProvider.notifier).refresh();
      messenger.showSnackBar(
        const SnackBar(content: Text('Recipe saved')),
      );
      _navigateBack();
    } else {
      final error = ref.read(addRecipeControllerProvider).error ?? 'Could not save';
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addRecipeControllerProvider);
    final flagsAsync = ref.watch(featureFlagControllerProvider);
    final imagesEnabled = flagsAsync.value?.imagesEnabled ?? true;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialRecipe == null ? 'Create Recipe' : 'Edit Recipe'),
        leading: BackButton(onPressed: _navigateBack),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MealType>(
              initialValue: _mealType,
              decoration: const InputDecoration(labelText: 'Meal Type'),
              items: MealType.values.map((e) {
                return DropdownMenuItem(value: e, child: Text(e.name));
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _mealType = v);
              },
            ),
            const SizedBox(height: 24),
            IngredientList(
              ingredients: addState.ingredients,
              onAdd: (ing) => ref
                  .read(addRecipeControllerProvider.notifier)
                  .addIngredient(ing),
              onUpdate: (idx, ing) => ref
                  .read(addRecipeControllerProvider.notifier)
                  .updateIngredient(idx, ing),
              onRemove: (idx) =>
                  ref.read(addRecipeControllerProvider.notifier).removeIngredient(idx),
            ),
            const SizedBox(height: 32),
            StepsList(
              steps: addState.steps,
              onAdd: (step) =>
                  ref.read(addRecipeControllerProvider.notifier).addStep(step),
              onUpdate: (idx, step) => ref
                  .read(addRecipeControllerProvider.notifier)
                  .updateStep(idx, step),
              onRemove: (idx) =>
                  ref.read(addRecipeControllerProvider.notifier).removeStep(idx),
              onMoveUp: (idx) =>
                  ref.read(addRecipeControllerProvider.notifier).moveStepUp(idx),
              onMoveDown: (idx) =>
                  ref.read(addRecipeControllerProvider.notifier).moveStepDown(idx),
            ),
            const SizedBox(height: 32),
            RecipeImageGrid(
              images: addState.images,
              isEnabled: imagesEnabled,
              disabledMessage: 'Image attachments are disabled right now.',
              onAddImage: () => ref
                  .read(addRecipeControllerProvider.notifier)
                  .addSampleImageForTest(),
              onRemove: (idx) => ref
                  .read(addRecipeControllerProvider.notifier)
                  .removeImage(idx),
            ),
            const SizedBox(height: 32),
            Semantics(
              label: widget.initialRecipe == null
                  ? 'Save recipe'
                  : 'Update recipe',
              button: true,
              child: FilledButton(
                key: const Key('save-recipe-button'),
                onPressed: addState.isSaving ? null : _save,
                child: addState.isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        widget.initialRecipe == null
                            ? 'Save Recipe'
                            : 'Update Recipe',
                      ),
              ),
            ),
            Semantics(
              label: 'Back to home',
              button: true,
              child: TextButton.icon(
                onPressed: _navigateBack,
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to home'),
              ),
            ),
            if (addState.error != null) ...[
              const SizedBox(height: 8),
              Text(
                addState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
