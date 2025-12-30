import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';

abstract class IngredientRepository {
  Future<List<PantryIngredient>> listIngredients();
  Future<PantryIngredient?> getIngredient(String id);
  Future<void> saveIngredient(PantryIngredient ingredient);
  Future<void> updateIngredient(PantryIngredient ingredient);
  Future<void> deleteIngredient(String id);
  Future<void> bulkUpdateIngredients(BulkIngredientUpdate update);
  Future<List<IngredientCategory>> listCategories();
  Future<void> saveCategory(IngredientCategory category);
  Future<List<PantryIngredient>> recoverCorruptedEntries();
}
