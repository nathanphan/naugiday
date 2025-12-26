import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/add_recipe_controller.dart';
import 'package:naugiday/presentation/providers/recipe_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/data/services/image_storage_service.dart';

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
  test('enforces image cap via controller', () async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWith((ref) => repo)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(addRecipeControllerProvider, (prev, next) {});
    addTearDown(sub.close);
    final controller = container.read(addRecipeControllerProvider.notifier);

    controller.setTitle('Image Recipe');
    controller.setMealType(MealType.dinner);
    controller.addIngredient(
      const Ingredient(id: 'i1', name: 'Flour', quantity: '1 cup'),
    );

    for (var i = 0; i < 5; i++) {
      await controller.addSampleImageForTest();
    }
    final ok = await controller.save();
    expect(ok, isTrue);
    expect(repo.store.single.images.length, 5);

    // Sixth image should not increase count
    await controller.addSampleImageForTest();
    expect(controller.state.images.length, 5);
  });

  test('rejects oversize image with error', () async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWith((ref) => repo)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(addRecipeControllerProvider, (prev, next) {});
    addTearDown(sub.close);
    final controller = container.read(addRecipeControllerProvider.notifier);
    controller.setTitle('Big Image');
    controller.setMealType(MealType.dinner);
    controller.addIngredient(
      const Ingredient(id: 'i1', name: 'Salt', quantity: '1 tsp'),
    );

    // Create oversize bytes (>5MB)
    final dir = await Directory.systemTemp.createTemp('big_img');
    final file = File('${dir.path}/big.jpg');
    await file.writeAsBytes(List<int>.filled(ImageStorageService.maxImageBytes + 1, 0));

    await controller.addImageFromFile(file);
    expect(controller.state.error, contains('Image too large'));
    expect(controller.state.images, isEmpty);
  });

  test('permission denied sets error but still allows save without images', () async {
    final repo = _MemoryRepo();
    final container = ProviderContainer(
      overrides: [recipeRepositoryProvider.overrideWith((ref) => repo)],
    );
    addTearDown(container.dispose);
    final controller = container.read(addRecipeControllerProvider.notifier);
    controller.setTitle('Perm Test');
    controller.setMealType(MealType.dinner);
    controller.addIngredient(
      const Ingredient(id: 'i1', name: 'Rice', quantity: '1 cup'),
    );

    controller.handlePermissionDenied();
    expect(controller.state.error, contains('Permission denied'));
    final ok = await controller.save();
    expect(ok, isTrue);
    expect(repo.store.single.images, isEmpty);
  });
}
