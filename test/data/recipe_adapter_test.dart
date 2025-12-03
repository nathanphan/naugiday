import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:naugiday/data/adapters/recipe_adapter.dart';
import 'package:naugiday/data/dtos/ingredient_dto.dart';
import 'package:naugiday/data/dtos/nutrition_info_dto.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';

void main() {
  const testBoxName = 'recipes_adapter_test';
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_adapter_test');
    Hive
      ..init(tempDir.path)
      ..registerAdapter(NutritionInfoDtoAdapter())
      ..registerAdapter(IngredientDtoAdapter())
      ..registerAdapter(RecipeDtoAdapter());
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(testBoxName);
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('recipe dto round-trips through Hive adapter', () async {
    final box = await Hive.openBox<RecipeDto>(testBoxName);
    final recipe = RecipeDto(
      id: 'r1',
      name: 'Pho Ga',
      description: 'Chicken pho',
      cookingTimeMinutes: 45,
      difficultyIndex: 1,
      ingredients: [
        IngredientDto(id: 'i1', name: 'Chicken', quantity: '500g'),
        IngredientDto(id: 'i2', name: 'Rice noodles', quantity: '200g'),
      ],
      steps: ['Simmer broth', 'Cook noodles'],
      nutrition: NutritionInfoDto(calories: 600, protein: 40, carbs: 70, fat: 15),
      mealTypeIndex: 1,
      isUserCreated: true,
      imageUrl: null,
    );

    await box.put(recipe.id, recipe);
    final stored = box.get(recipe.id);

    expect(stored, isNotNull);
    expect(stored!.name, equals('Pho Ga'));
    expect(stored.ingredients.length, 2);
    expect(stored.steps.first, equals('Simmer broth'));
    expect(stored.nutrition.protein, equals(40));
  });
}
