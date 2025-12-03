import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/domain/usecases/list_recipes.dart';
import 'package:naugiday/domain/usecases/save_recipe.dart';
import 'package:naugiday/domain/usecases/update_recipe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_controller.g.dart';

@Riverpod(keepAlive: true)
class RecipeController extends _$RecipeController {
  late final RecipeRepository _repository;
  late final SaveRecipe _saveRecipe;
  late final ListRecipes _listRecipes;
  late final UpdateRecipe _updateRecipe;

  @override
  Future<List<Recipe>> build() async {
    _repository = ref.watch(recipeRepositoryProvider);
    _saveRecipe = SaveRecipe(_repository);
    _listRecipes = ListRecipes(_repository);
    _updateRecipe = UpdateRecipe(_repository);
    return _listRecipes();
  }

  Future<void> refresh() async {
    final previous = state;
    state = const AsyncLoading();
    try {
      final recipes = await _listRecipes();
      if (!ref.mounted) return;
      state = AsyncData(recipes);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<Recipe>>(err, stack).copyWithPrevious(previous);
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _runAndReload(() => _saveRecipe(recipe));
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _runAndReload(() => _updateRecipe(recipe));
  }

  Future<void> deleteRecipe(String id) async {
    await _runAndReload(() => _repository.deleteRecipe(id));
  }

  Future<void> recoverStorage() async {
    final previous = state;
    state = const AsyncLoading();
    try {
      final recipes = await _repository.recoverCorruptedEntries();
      if (!ref.mounted) return;
      state = AsyncData(recipes);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<Recipe>>(err, stack).copyWithPrevious(previous);
    }
  }

  Future<void> _runAndReload(Future<void> Function() action) async {
    final previous = state;
    try {
      await action();
      final recipes = await _listRecipes();
      if (!ref.mounted) return;
      state = AsyncData(recipes);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<Recipe>>(err, stack).copyWithPrevious(previous);
    }
  }
}
