import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:uuid/uuid.dart';

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
    final existing = widget.initialRecipe;
    if (existing != null) {
      _nameController.text = existing.name;
      _descController.text = existing.description;
      _mealType = existing.mealType;
    }
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
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final base = widget.initialRecipe;
      final recipe = Recipe(
        id: base?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descController.text,
        cookingTimeMinutes: base?.cookingTimeMinutes ?? 30,
        difficulty: base?.difficulty ?? RecipeDifficulty.medium,
        ingredients: base?.ingredients ?? [],
        steps: base?.steps ?? [],
        nutrition: base?.nutrition ??
            const NutritionInfo(
              calories: 0,
              protein: 0,
              carbs: 0,
              fat: 0,
            ),
        mealType: _mealType,
        isUserCreated: base?.isUserCreated ?? true,
        imageUrl: base?.imageUrl,
        createdAt: base?.createdAt ?? now,
        updatedAt: now,
      );

      final notifier = ref.read(recipeControllerProvider.notifier);
      if (base != null) {
        await notifier.updateRecipe(recipe);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe updated')),
        );
      } else {
        await notifier.addRecipe(recipe);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe saved')),
        );
      }

      if (!mounted) return;
      _navigateBack();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _save,
              child:
                  Text(widget.initialRecipe == null ? 'Save Recipe' : 'Update Recipe'),
            ),
            TextButton.icon(
              onPressed: _navigateBack,
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
