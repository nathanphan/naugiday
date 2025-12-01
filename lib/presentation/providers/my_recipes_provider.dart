import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_recipes_provider.g.dart';

@riverpod
class MyRecipes extends _$MyRecipes {
  @override
  Future<List<Recipe>> build() async {
    final repo = ref.watch(recipeRepositoryProvider);
    return repo.getMyRecipes();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final repo = ref.read(recipeRepositoryProvider);
    await repo.saveRecipe(recipe);
    ref.invalidateSelf();
  }

  Future<void> deleteRecipe(String id) async {
    final repo = ref.read(recipeRepositoryProvider);
    await repo.deleteRecipe(id);
    ref.invalidateSelf();
  }
}
