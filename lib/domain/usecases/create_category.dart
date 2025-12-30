import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class CreateCategory {
  CreateCategory(this._repository);

  final IngredientRepository _repository;

  Future<void> call(IngredientCategory category) {
    return _repository.saveCategory(category);
  }
}
