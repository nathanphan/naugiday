import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/add_recipe_controller.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
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
    // Editing flow can prefill later when connected to existing recipes.
  }

  void _navigateBack() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go('/my-recipes');
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final messenger = ScaffoldMessenger.of(context);
    final addNotifier = ref.read(addRecipeControllerProvider.notifier);
    addNotifier.setTitle(_nameController.text);
    addNotifier.setDescription(_descController.text);
    addNotifier.setMealType(_mealType);
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
              onAddImage: () =>
                  ref.read(addRecipeControllerProvider.notifier).addSampleImageForTest(),
              onRemove: (idx) =>
                  ref.read(addRecipeControllerProvider.notifier).removeImage(idx),
            ),
            const SizedBox(height: 32),
            FilledButton(
              key: const Key('save-recipe-button'),
              onPressed: addState.isSaving ? null : _save,
              child: addState.isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.initialRecipe == null ? 'Save Recipe' : 'Update Recipe'),
            ),
            TextButton.icon(
              onPressed: _navigateBack,
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to home'),
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
