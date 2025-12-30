import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class ListCategories {
  ListCategories(this._repository);

  final IngredientRepository _repository;

  Future<List<IngredientCategory>> call() {
    return _repository.listCategories();
  }
}
