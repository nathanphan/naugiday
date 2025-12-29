import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naugiday/core/constants/app_assets.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';
import 'package:naugiday/presentation/widgets/skeletons.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  final List<String> detectedIngredients;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.detectedIngredients,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _showSkeleton = true;
  bool _isSaved = true;

  void _navigateBack() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go('/my-recipes');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(AppTheme.animFast, () {
        if (mounted) {
          setState(() {
            _showSkeleton = false;
          });
        }
      });
    });
  }

  Future<void> _toggleSave(WidgetRef ref) async {
    final notifier = ref.read(recipeControllerProvider.notifier);
    if (_isSaved) {
      await notifier.deleteRecipe(widget.recipe.id);
    } else {
      await notifier.addRecipe(widget.recipe);
    }
    if (!mounted) return;
    setState(() => _isSaved = !_isSaved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isSaved ? 'Recipe saved' : 'Recipe removed')),
    );
  }

  void _shareRecipe() {
    final recipe = widget.recipe;
    final buffer = StringBuffer()
      ..writeln(recipe.name)
      ..writeln()
      ..writeln('Ingredients:')
      ..writeln(recipe.ingredients.map((i) => '- ${i.quantity} ${i.name}').join('\n'))
      ..writeln()
      ..writeln('Steps:')
      ..writeln(recipe.steps.asMap().entries.map((e) => '${e.key + 1}. ${e.value}').join('\n'));
    Share.share(buffer.toString(), subject: 'Recipe: ${recipe.name}');
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final detectedIngredients = widget.detectedIngredients;
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
          onPressed: _navigateBack,
          tooltip: 'Back to previous',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/create-recipe', extra: {'recipe': recipe}),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete recipe?'),
                      content: Text('Remove "${recipe.name}" from My Recipes?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ??
                  false;
              if (!confirm) return;
              await ref.read(recipeControllerProvider.notifier).deleteRecipe(recipe.id);
              if (context.mounted) _navigateBack();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _showSkeleton
              ? const SkeletonBlock(height: 200)
              : Hero(
                  tag: recipe.id,
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(AppAssets.foodPlaceholder, fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(height: 16),
          if (_showSkeleton)
            const SkeletonBlock(height: 20, width: double.infinity)
          else
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const SizedBox(height: 16),
          _showSkeleton ? const SkeletonBlock(height: 80) : _buildNutritionSection(context),
          const Divider(height: 32),
          if (!_showSkeleton)
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: [
                FilledButton.icon(
                  onPressed: () => _toggleSave(ref),
                  icon: Icon(_isSaved ? Icons.bookmark_remove : Icons.bookmark_add_outlined),
                  label: Text(_isSaved ? 'Unsave' : 'Save'),
                ),
                OutlinedButton.icon(
                  onPressed: _shareRecipe,
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/shopping-list'),
                  icon: const Icon(Icons.playlist_add_check),
                  label: const Text('Add missing items'),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (_showSkeleton) ...[
            const SkeletonBlock(height: 16, width: 180),
            const SizedBox(height: 8),
            const SkeletonBlock(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBlock(height: 14, width: double.infinity),
          ] else ...[
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
          ],
          const Divider(height: 32),
          Text('Steps', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (_showSkeleton) ...[
            const SkeletonBlock(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBlock(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonBlock(height: 14, width: 200),
          ] else ...[
            ...recipe.steps.asMap().entries.map(
              (entry) => ListTile(
                leading: CircleAvatar(child: Text('${entry.key + 1}')),
                title: Text(entry.value),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OutlinedButton.icon(
            onPressed: _navigateBack,
            icon: const Icon(Icons.home_outlined),
            label: const Text('Back to home'),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionSection(BuildContext context) {
    final recipe = widget.recipe;
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
