import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_recipe_repository.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return LocalRecipeRepository();
}

class LocalRecipeRepository implements RecipeRepository {
  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(recipesBoxName)) {
      await initHiveForRecipes();
    }
    final Box box = Hive.box(recipesBoxName);
    await _migrateLegacyStrings(box);
    return box;
  }

  Future<void> _migrateLegacyStrings(Box box) async {
    // Older versions stored JSON strings in the same box.
    if (box.isEmpty) return;
    final entries = box.toMap();
    var mutated = false;
    for (final entry in entries.entries) {
      final value = entry.value;
      if (value is String) {
        try {
          final dto = RecipeDto.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          );
          await box.put(entry.key, dto);
          mutated = true;
        } catch (_) {
          // Skip malformed legacy entry to avoid crashing; leave as-is.
        }
      }
    }
    if (mutated) {
      await box.flush();
    }
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    final box = await _getBox();
    return box.values
        .whereType<RecipeDto>()
        .map((dto) => dto.toDomain())
        .toList();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    final box = await _getBox();
    await box.put(recipe.id, RecipeDto.fromDomain(recipe));
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    final box = await _getBox();
    await box.put(recipe.id, RecipeDto.fromDomain(recipe));
  }

  @override
  Future<void> deleteRecipe(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
