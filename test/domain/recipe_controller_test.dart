import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';

class _FakeRecipeRepo implements RecipeRepository {
  final List<Recipe> _store = [];
  final Duration delay;

  _FakeRecipeRepo({this.delay = Duration.zero});

  @override
  Future<void> deleteRecipe(String id) async {
    if (delay != Duration.zero) {
      await Future.delayed(delay);
    }
    _store.removeWhere((r) => r.id == id);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    if (delay != Duration.zero) {
      await Future.delayed(delay);
    }
    return List.unmodifiable(_store);
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    if (delay != Duration.zero) {
      await Future.delayed(delay);
    }
    _store.removeWhere((r) => r.id == recipe.id);
    _store.add(recipe);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await saveRecipe(recipe);
  }
}

Recipe _makeRecipe({String id = 'r1'}) => Recipe(
  id: id,
  name: 'Test Recipe',
  description: 'Desc',
  cookingTimeMinutes: 10,
  difficulty: RecipeDifficulty.easy,
  ingredients: [Ingredient(id: 'i1', name: 'Item', quantity: '1')],
  steps: const ['Do it'],
  nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
  mealType: MealType.dinner,
  isUserCreated: true,
);

void main() {
  test('addRecipe hydrates timestamps and refreshes list', () async {
    final repo = _FakeRecipeRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(recipeControllerProvider.notifier);
    await notifier.addRecipe(_makeRecipe());

    final recipes = await container.read(recipeControllerProvider.future);
    expect(recipes, isNotEmpty);
    expect(recipes.first.createdAt, isNotNull);
    expect(recipes.first.updatedAt, isNotNull);
  });

  test('deleteRecipe removes entry', () async {
    final repo = _FakeRecipeRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(recipeControllerProvider.notifier);
    await notifier.addRecipe(_makeRecipe(id: 'r-del'));
    await notifier.deleteRecipe('r-del');

    final recipes = await container.read(recipeControllerProvider.future);
    expect(recipes, isEmpty);
  });

  test('controller guards state updates after dispose', () async {
    final repo = _FakeRecipeRepo(delay: const Duration(milliseconds: 10));
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWithValue(repo)],
    );

    final notifier = container.read(recipeControllerProvider.notifier);
    final future = notifier.addRecipe(_makeRecipe(id: 'r-late'));
    container.dispose(); // dispose before async work completes
    await expectLater(future, completes);
  });
}
