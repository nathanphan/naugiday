import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';

void main() {
  late Directory tempDir;
  late LocalRecipeRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_repo_test');
    await initHiveForRecipes(storagePath: tempDir.path, useFlutter: false);
    repository = LocalRecipeRepository();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(recipesBoxName);
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  Recipe recipeFixture({String id = 'r-save'}) => Recipe(
        id: id,
        name: 'Bun Cha',
        description: 'Hanoi grilled pork with noodles',
        cookingTimeMinutes: 40,
        difficulty: RecipeDifficulty.medium,
        ingredients: [
          Ingredient(id: 'i1', name: 'Pork', quantity: '300g'),
          Ingredient(id: 'i2', name: 'Noodles', quantity: '200g'),
        ],
        steps: const ['Grill pork', 'Assemble bowl'],
        nutrition:
            const NutritionInfo(calories: 700, protein: 45, carbs: 60, fat: 25),
        mealType: MealType.lunch,
        isUserCreated: true,
        imageUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  test('save and list recipes', () async {
    final recipe = recipeFixture();
    await repository.saveRecipe(recipe);

    final recipes = await repository.getMyRecipes();
    expect(recipes.length, 1);
    expect(recipes.first.name, equals('Bun Cha'));
  });

  test('delete recipe removes entry', () async {
    final recipe = recipeFixture();
    await repository.saveRecipe(recipe);
    await repository.deleteRecipe(recipe.id);

    final recipes = await repository.getMyRecipes();
    expect(recipes, isEmpty);
  });

  test('migrates legacy string entries to RecipeDto', () async {
    final box = Hive.box(recipesBoxName);
    final legacy = RecipeDto.fromDomain(recipeFixture(id: 'legacy'));
    await box.put('legacy', jsonEncode(legacy.toJson()));

    final recipes = await repository.getMyRecipes();
    expect(recipes.length, 1);
    expect(recipes.first.id, 'legacy');
  });
}
