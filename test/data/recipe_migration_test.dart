import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/dtos/ingredient_dto.dart';
import 'package:naugiday/data/dtos/nutrition_info_dto.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/meal_type.dart';

class _InMemoryRecipesStore implements RecipesStore {
  final Map<dynamic, dynamic> raw = {};

  @override
  Future<void> delete(key) async => raw.remove(key);

  @override
  Future<void> flush() async {}

  @override
  bool get isEmpty => raw.isEmpty;

  @override
  bool get isOpen => true;

  @override
  Future<void> put(key, value) async {
    raw[key] = value;
  }

  @override
  Map toMap() => Map.unmodifiable(raw);

  @override
  Iterable get values => raw.values;
}

RecipeDto _legacyDto() => RecipeDto(
      id: 'legacy-id',
      name: 'Legacy Recipe',
      description: 'Old entry without new fields',
      cookingTimeMinutes: 10,
      difficultyIndex: 0,
      ingredients: [IngredientDto(id: 'i1', name: 'Item', quantity: '1')],
      steps: const ['Step'],
      nutrition: NutritionInfoDto(calories: 1, protein: 1, carbs: 1, fat: 1),
      mealTypeIndex: MealType.dinner.index,
      isUserCreated: true,
      imageUrl: null,
      createdAt: null,
      updatedAt: null,
    );

void main() {
  test('forward-compat migration keeps legacy recipes readable with defaults', () async {
    final store = _InMemoryRecipesStore();
    // Seed legacy entry missing optional future fields (createdAt/updatedAt).
    store.raw['legacy-id'] = _legacyDto();

    final repo = LocalRecipeRepository(storeOverride: store);
    final recipes = await repo.getMyRecipes();

    expect(recipes, isNotEmpty);
    final recipe = recipes.first;
    expect(recipe.id, 'legacy-id');
    expect(recipe.name, 'Legacy Recipe');
    expect(recipe.createdAt, isNull); // defaulted safely
    expect(recipe.updatedAt, isNull); // defaulted safely
  });
}
