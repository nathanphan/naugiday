import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';

class UpdateRecipe {
  UpdateRecipe(this._repository);

  final RecipeRepository _repository;

  Future<void> call(Recipe recipe) async {
    final hydrated = recipe.copyWith(updatedAt: DateTime.now());
    await _repository.updateRecipe(hydrated);
  }
}
