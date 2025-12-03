import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';

class ListRecipes {
  ListRecipes(this._repository);

  final RecipeRepository _repository;

  Future<List<Recipe>> call() async {
    final recipes = [...await _repository.getMyRecipes()];
    recipes.sort(
      (a, b) =>
          (b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
              .compareTo(
                a.updatedAt ??
                    a.createdAt ??
                    DateTime.fromMillisecondsSinceEpoch(0),
              ),
    );
    return recipes;
  }
}
