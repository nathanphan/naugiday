import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/data/services/image_storage_service.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';
import 'package:naugiday/domain/errors/recipe_storage_exception.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_recipe_repository.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return LocalRecipeRepository();
}

class LocalRecipeRepository implements RecipeRepository {
  LocalRecipeRepository({
    RecipesStore? storeOverride,
    ImageStorageService? imageStorageService,
  })  : _storeOverride = storeOverride,
        _imageStorage = imageStorageService ?? ImageStorageService();

  final RecipesStore? _storeOverride;
  final ImageStorageService _imageStorage;

  Future<RecipesStore> _getStore() async {
    final storeOverride = _storeOverride;
    if (storeOverride != null) {
      await _migrateLegacyStrings(storeOverride);
      return storeOverride;
    }
    if (!Hive.isBoxOpen(recipesBoxName)) {
      await initHiveForRecipes();
    }
    final Box box = Hive.box(recipesBoxName);
    final store = HiveRecipesStore(box);
    await _migrateLegacyStrings(store);
    return store;
  }

  Future<void> _migrateLegacyStrings(RecipesStore store) async {
    // Older versions stored JSON strings in the same box.
    if (store.isEmpty) return;
    final entries = store.toMap();
    var mutated = false;
    for (final entry in entries.entries) {
      final value = entry.value;
      if (value is String) {
        try {
          final dto = RecipeDto.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          );
          await store.put(entry.key, dto);
          mutated = true;
        } catch (_) {
          // Skip malformed legacy entry to avoid crashing; leave as-is.
        }
      }
    }
    if (mutated) {
      await store.flush();
    }
  }

  bool _isValidDto(Object? value) {
    if (value is! RecipeDto) return false;
    if (value.id.isEmpty || value.name.isEmpty) return false;
    return true;
  }

  Future<List<Recipe>> _readValidated(RecipesStore store) async {
    final entries = store.toMap();
    final recipes = <Recipe>[];
    final corruptedKeys = <dynamic>[];
    for (final entry in entries.entries) {
      final value = entry.value;
      try {
        if (!_isValidDto(value)) {
          corruptedKeys.add(entry.key);
          continue;
        }
        recipes.add((value as RecipeDto).toDomain());
      } catch (_) {
        corruptedKeys.add(entry.key);
      }
    }
    if (corruptedKeys.isNotEmpty) {
      throw RecipeStorageException.corrupted(corruptedKeys);
    }
    return recipes;
  }

  Future<void> _safeWrite(
    Future<void> Function(RecipesStore store) writer,
  ) async {
    final store = await _getStore();
    try {
      await writer(store);
    } catch (err) {
      if (err is RecipeStorageException) rethrow;
      throw RecipeStorageException.write(err);
    }
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    final store = await _getStore();
    try {
      return await _readValidated(store);
    } catch (err) {
      if (err is RecipeStorageException) rethrow;
      throw RecipeStorageException.read(err);
    }
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    await _safeWrite((store) async {
      final withImages = await _persistImages(recipe);
      final dto = RecipeDto.fromDomain(withImages);
      await store.put(dto.id, dto);
    });
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await _safeWrite((store) async {
      final withImages = await _persistImages(recipe);
      final dto = RecipeDto.fromDomain(withImages);
      await store.put(dto.id, dto);
    });
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _safeWrite((store) => store.delete(id));
  }

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async {
    final store = await _getStore();
    final entries = store.toMap();
    final corruptedKeys = <dynamic>[];
    for (final entry in entries.entries) {
      if (!_isValidDto(entry.value)) {
        corruptedKeys.add(entry.key);
      }
    }
    for (final key in corruptedKeys) {
      await store.delete(key);
    }
    await store.flush();
    return _readValidated(store);
  }

  Future<Recipe> _persistImages(Recipe recipe) async {
    if (recipe.images.isEmpty) return recipe;
    if (recipe.images.length > ImageStorageService.maxImagesPerRecipe) {
      throw RecipeStorageException.write(
        'Too many images (max ${ImageStorageService.maxImagesPerRecipe})',
      );
    }
    final updatedImages = <RecipeImage>[];
    for (final image in recipe.images) {
      final existingPath = File(image.localPath);
      final exists = await existingPath.exists();
      if (!exists) continue;
      final size = await existingPath.length();
      if (!_imageStorage.isSizeAllowed(size)) {
        throw RecipeStorageException.write(
          'Image too large (max ${ImageStorageService.maxImageBytes} bytes)',
        );
      }
      final savedFile =
          await _imageStorage.saveImage(existingPath, recipeId: recipe.id);
      updatedImages.add(
        image.copyWith(
          localPath: savedFile.path,
          fileName: savedFile.uri.pathSegments.last,
          fileSizeBytes: size,
          addedAt: image.addedAt ?? DateTime.now(),
        ),
      );
    }
    return recipe.copyWith(images: updatedImages);
  }
}

abstract class RecipesStore {
  bool get isOpen;
  bool get isEmpty;
  Map<dynamic, dynamic> toMap();
  Iterable<dynamic> get values;
  Future<void> put(dynamic key, dynamic value);
  Future<void> delete(dynamic key);
  Future<void> flush();
}

class HiveRecipesStore implements RecipesStore {
  HiveRecipesStore(this._box);

  final Box _box;

  @override
  Future<void> delete(key) => _box.delete(key);

  @override
  Future<void> flush() => _box.flush();

  @override
  bool get isEmpty => _box.isEmpty;

  @override
  bool get isOpen => _box.isOpen;

  @override
  Future<void> put(key, value) => _box.put(key, value);

  @override
  Map toMap() => _box.toMap();

  @override
  Iterable get values => _box.values;
}
