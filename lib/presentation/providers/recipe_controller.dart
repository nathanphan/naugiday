import 'package:naugiday/data/repositories/local_recipe_repository.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/domain/usecases/list_recipes.dart';
import 'package:naugiday/domain/usecases/save_recipe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recipe_controller.g.dart';

@riverpod
class RecipeController extends _$RecipeController {
  late final RecipeRepository _repository;
  late final SaveRecipe _saveRecipe;
  late final ListRecipes _listRecipes;

  @override
  Future<List<Recipe>> build() async {
    _repository = ref.watch(recipeRepositoryProvider);
    _saveRecipe = SaveRecipe(_repository);
    _listRecipes = ListRecipes(_repository);
    return _listRecipes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _listRecipes());
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _saveRecipe(recipe);
    if (!ref.mounted) return;
    state = await AsyncValue.guard(() => _listRecipes());
  }

  Future<void> deleteRecipe(String id) async {
    await _repository.deleteRecipe(id);
    if (!ref.mounted) return;
    state = await AsyncValue.guard(() => _listRecipes());
  }
}
