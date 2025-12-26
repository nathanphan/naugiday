import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/cooking_step.dart';
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
  test('steps maintain order after move', () async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWith((ref) => repo)],
    );
    addTearDown(container.dispose);
    final controller = container.read(addRecipeControllerProvider.notifier);

    controller.setTitle('Steps Recipe');
    controller.setMealType(MealType.dinner);
    controller.addIngredient(
      const Ingredient(id: 'i1', name: 'Water', quantity: '1 cup'),
    );
    controller.addStep(
      CookingStep(id: 's1', position: 1, instruction: 'First'),
    );
    controller.addStep(
      CookingStep(id: 's2', position: 2, instruction: 'Second'),
    );
    controller.moveStepUp(1);

    final saved = await controller.save();
    expect(saved, isTrue);
    final recipes = await repo.getMyRecipes();
    expect(recipes.single.cookingSteps.first.instruction, 'Second');
    expect(recipes.single.cookingSteps.first.position, 1);
    expect(recipes.single.steps.first, 'Second');
  });
}
