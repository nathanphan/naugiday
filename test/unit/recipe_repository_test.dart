import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/data/services/image_storage_service.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';
import 'package:naugiday/domain/entities/recipe_entities.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';

class _InMemoryStore implements RecipesStore {
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
  Future<void> put(key, value) async => raw[key] = value;

  @override
  Map toMap() => Map.unmodifiable(raw);

  @override
  Iterable get values => raw.values;
}

Recipe _recipe({List<RecipeImage>? images}) => Recipe(
      id: 'r1',
      name: 'Test',
      description: 'Desc',
      cookingTimeMinutes: 15,
      difficulty: RecipeDifficulty.easy,
      ingredients: const [
        Ingredient(id: 'i1', name: 'Salt', quantity: '1 tsp', quantityValue: 1),
      ],
      steps: const ['Step 1'],
      nutrition: const NutritionInfo(
        calories: 10,
        protein: 1,
        carbs: 1,
        fat: 1,
      ),
      mealType: MealType.dinner,
      isUserCreated: true,
      images: images ?? const [],
    );

class _FakeImageStorageService extends ImageStorageService {
  final List<File> saved = [];
  @override
  Future<File> saveImage(File source, {required String recipeId}) async {
    saved.add(source);
    return source;
  }
}

void main() {
  group('Recipe validation', () {
    test('requires title, ingredient, and positive quantity', () {
      final invalid = _recipe().copyWith(
        name: '',
        ingredients: const [
          Ingredient(
            id: 'i1',
            name: '',
            quantity: '',
            quantityValue: -1,
          ),
        ],
      );
      final result = validateRecipeDraft(invalid);
      expect(result.isValid, isFalse);
      expect(result.errors, isNotEmpty);
    });

    test('fails when too many images', () {
      final images = List.generate(
        ImageStorageService.maxImagesPerRecipe + 1,
        (i) => RecipeImage(
          id: 'img$i',
          localPath: '/tmp/img$i.jpg',
          fileName: 'img$i.jpg',
          fileSizeBytes: 100,
        ),
      );
      final result = validateRecipeDraft(_recipe(images: images));
      expect(result.isValid, isFalse);
    });
  });

  group('LocalRecipeRepository', () {
    late LocalRecipeRepository repo;
    late _InMemoryStore store;

    setUp(() {
      store = _InMemoryStore();
      repo = LocalRecipeRepository(
        storeOverride: store,
        imageStorageService: _FakeImageStorageService(),
      );
    });

    test('migrates legacy string entries to RecipeDto', () async {
      final dtoJson = RecipeDto.fromDomain(_recipe()).toJson();
      store.raw['legacy'] = jsonEncode(dtoJson);

    final recipes = await repo.getMyRecipes();
    // legacy string migrates into RecipeDto and remains readable
    expect(recipes.length, 1);
    expect(recipes.first.id, 'r1');
  });

    test('persists and reads recipe', () async {
      final recipe = _recipe();
      await repo.saveRecipe(recipe);
      final all = await repo.getMyRecipes();
      expect(all.single.name, recipe.name);
    });

    test('rejects oversize image', () async {
      final temp = File('${Directory.systemTemp.path}/oversize.jpg');
      await temp.writeAsBytes(List.filled(ImageStorageService.maxImageBytes + 1, 0));
      final recipe = _recipe(
        images: [
          RecipeImage(
            id: 'img1',
            localPath: temp.path,
            fileName: 'oversize.jpg',
            fileSizeBytes: ImageStorageService.maxImageBytes + 1,
          ),
        ],
      );
      expect(
        () => repo.saveRecipe(recipe),
        throwsA(isA<RecipeStorageException>()),
      );
    });
  });
}
