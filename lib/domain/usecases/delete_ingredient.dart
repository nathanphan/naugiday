import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class DeleteIngredient {
  DeleteIngredient(this._repository);

  final IngredientRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteIngredient(id);
  }
}
