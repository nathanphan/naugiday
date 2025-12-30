import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class ListIngredients {
  ListIngredients(this._repository);

  final IngredientRepository _repository;

  Future<List<PantryIngredient>> call() {
    return _repository.listIngredients();
  }
}
