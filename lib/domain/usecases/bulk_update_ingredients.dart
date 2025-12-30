import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';

class BulkUpdateIngredients {
  BulkUpdateIngredients(this._repository);

  final IngredientRepository _repository;

  Future<void> call(BulkIngredientUpdate update) {
    return _repository.bulkUpdateIngredients(update);
  }
}
