import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';

class _InMemoryRecipesStore implements RecipesStore {
  final Map<dynamic, dynamic> raw = {};
  bool failNextPut = false;

  @override
  Future<void> delete(key) async {
    raw.remove(key);
  }

  @override
  Future<void> flush() async {}

  @override
  bool get isEmpty => raw.isEmpty;

  @override
  bool get isOpen => true;

  @override
  Future<void> put(key, value) async {
    if (failNextPut) {
      failNextPut = false;
      throw Exception('simulated write failure');
    }
    raw[key] = value;
  }

  @override
  Map toMap() => Map.unmodifiable(raw);

  @override
  Iterable get values => raw.values;
}

Recipe _makeRecipe(String id) => Recipe(
      id: id,
      name: 'Recipe $id',
      description: 'Desc',
      cookingTimeMinutes: 10,
      difficulty: RecipeDifficulty.easy,
      ingredients: [Ingredient(id: 'i$id', name: 'Item', quantity: '1')],
      steps: const ['Step'],
      nutrition: const NutritionInfo(calories: 1, protein: 1, carbs: 1, fat: 1),
      mealType: MealType.dinner,
      isUserCreated: true,
    );

void main() {
  test('write failure preserves existing recipes and allows retry', () async {
    final store = _InMemoryRecipesStore();
    final repo = LocalRecipeRepository(storeOverride: store);

    await repo.saveRecipe(_makeRecipe('r1'));
    expect(await repo.getMyRecipes(), hasLength(1));

    store.failNextPut = true;
    await expectLater(
      repo.saveRecipe(_makeRecipe('r2')),
      throwsA(isA<RecipeStorageException>()),
    );

    final afterFailure = await repo.getMyRecipes();
    expect(afterFailure.map((r) => r.id), contains('r1'));
    expect(afterFailure.map((r) => r.id), isNot(contains('r2')));

    await repo.saveRecipe(_makeRecipe('r2'));
    final recovered = await repo.getMyRecipes();
    expect(recovered.map((r) => r.id), containsAll(['r1', 'r2']));
  });

  test('recoverCorruptedEntries removes invalid entries', () async {
    final store = _InMemoryRecipesStore();
    final repo = LocalRecipeRepository(storeOverride: store);

    await repo.saveRecipe(_makeRecipe('r1'));
    store.raw['bad'] = 'not a recipe';

    final recovered = await repo.recoverCorruptedEntries();
    expect(recovered.map((r) => r.id), contains('r1'));
    expect(store.raw.containsKey('bad'), isFalse);
  });
}
