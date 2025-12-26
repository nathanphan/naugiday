import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/add_recipe_controller.dart';
import 'package:naugiday/presentation/providers/recipe_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _MemoryRepo implements RecipeRepository {
  final List<Recipe> store = [];
  @override
  Future<void> deleteRecipe(String id) async => store.removeWhere((r) => r.id == id);
  @override
  Future<List<Recipe>> getMyRecipes() async => List.unmodifiable(store);
  @override
  Future<List<Recipe>> recoverCorruptedEntries() async => getMyRecipes();
  @override
  Future<void> saveRecipe(Recipe recipe) async {
    store.removeWhere((r) => r.id == recipe.id);
    store.add(recipe);
  }
  @override
  Future<void> updateRecipe(Recipe recipe) async => saveRecipe(recipe);
}

void main() {
  test('offline save and reopen retains ingredients', () async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWith((ref) => repo)],
    );
    addTearDown(container.dispose);
    final controller = container.read(addRecipeControllerProvider.notifier);

    controller.setTitle('Com Ga');
    controller.setMealType(MealType.dinner);
    controller.addIngredient(
      const Ingredient(id: 'i1', name: 'Rice', quantity: '1 cup'),
    );

    final ok = await controller.save();
    expect(ok, isTrue);

    // Simulate reopen by reading from repo.
    final saved = await repo.getMyRecipes();
    expect(saved.single.name, 'Com Ga');
    expect(saved.single.ingredients.first.name, 'Rice');
  });
}
