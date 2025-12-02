import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';

class SaveRecipe {
  SaveRecipe(this._repository);

  final RecipeRepository _repository;

  Future<void> call(Recipe recipe) async {
    final now = DateTime.now();
    final hydrated = recipe.copyWith(
      createdAt: recipe.createdAt ?? now,
      updatedAt: now,
    );
    await _repository.saveRecipe(hydrated);
  }
}
