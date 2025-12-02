import 'package:flutter/material.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/core/constants/app_assets.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  final List<String> detectedIngredients;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.detectedIngredients,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize for comparison
    final detectedSet = detectedIngredients.map((e) => e.toLowerCase()).toSet();

    final haveIngredients = recipe.ingredients
        .where((i) => detectedSet.contains(i.name.toLowerCase()))
        .toList();
    final missingIngredients = recipe.ingredients
        .where((i) => !detectedSet.contains(i.name.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back to previous',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.asset(AppAssets.foodPlaceholder, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),
          Text(
            recipe.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildNutritionSection(context),
          const Divider(height: 32),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (haveIngredients.isNotEmpty) ...[
            Text(
              'From your fridge:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.green),
            ),
            ...haveIngredients.map(
              (i) => ListTile(
                leading: const Icon(Icons.check, color: Colors.green),
                title: Text(i.name),
                dense: true,
              ),
            ),
          ],
          if (missingIngredients.isNotEmpty) ...[
            Text(
              'You may need to buy:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.orange),
            ),
            ...missingIngredients.map(
              (i) => ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.orange),
                title: Text(i.name),
                dense: true,
              ),
            ),
          ],
          const Divider(height: 32),
          Text('Steps', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...recipe.steps.asMap().entries.map(
            (entry) => ListTile(
              leading: CircleAvatar(child: Text('${entry.key + 1}')),
              title: Text(entry.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Back to home'),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNutrient('Calories', '${recipe.nutrition.calories}'),
            _buildNutrient('Protein', '${recipe.nutrition.protein}g'),
            _buildNutrient('Carbs', '${recipe.nutrition.carbs}g'),
            _buildNutrient('Fat', '${recipe.nutrition.fat}g'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrient(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
