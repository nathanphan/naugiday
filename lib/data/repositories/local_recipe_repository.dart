import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_recipe_repository.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return LocalRecipeRepository();
}

class LocalRecipeRepository implements RecipeRepository {
  static const String _boxName = 'recipes';

  Future<Box<String>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async {
    final box = await _getBox();
    return box.values.map((jsonStr) {
      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return RecipeDto.fromJson(jsonMap).toDomain();
    }).toList();
  }

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    final box = await _getBox();
    final dto = RecipeDto.fromDomain(recipe);
    final jsonStr = jsonEncode(dto.toJson());
    await box.put(recipe.id, jsonStr);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
