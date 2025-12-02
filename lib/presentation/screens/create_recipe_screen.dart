import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:uuid/uuid.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final recipe = Recipe(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descController.text,
        cookingTimeMinutes: 30, // Default
        difficulty: RecipeDifficulty.medium, // Default
        ingredients: [], // Empty for MVP
        steps: [], // Empty for MVP
        nutrition: const NutritionInfo(
          calories: 0,
          protein: 0,
          carbs: 0,
          fat: 0,
        ),
        mealType: _mealType,
        isUserCreated: true,
        createdAt: now,
        updatedAt: now,
      );

      ref.read(recipeControllerProvider.notifier).addRecipe(recipe);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
        leading: BackButton(onPressed: () => context.pop()),
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
            FilledButton(onPressed: _save, child: const Text('Save Recipe')),
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
