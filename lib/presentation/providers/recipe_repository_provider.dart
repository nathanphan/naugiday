import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_repository_provider.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return LocalRecipeRepository();
}
