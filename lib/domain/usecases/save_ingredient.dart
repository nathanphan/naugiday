import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class SaveIngredient {
  SaveIngredient(this._repository);

  final IngredientRepository _repository;

  Future<void> call(PantryIngredient ingredient) {
    return _repository.saveIngredient(ingredient);
  }
}
