import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class GetIngredient {
  GetIngredient(this._repository);

  final IngredientRepository _repository;

  Future<PantryIngredient?> call(String id) {
    return _repository.getIngredient(id);
  }
}
