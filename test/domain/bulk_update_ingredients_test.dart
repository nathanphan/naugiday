import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:naugiday/domain/usecases/bulk_update_ingredients.dart';

class _FakeIngredientRepository implements IngredientRepository {
  BulkIngredientUpdate? lastUpdate;

  @override
  Future<List<PantryIngredient>> listIngredients() async => [];

  @override
  Future<PantryIngredient?> getIngredient(String id) async => null;

  @override
  Future<void> saveIngredient(PantryIngredient ingredient) async {}

  @override
  Future<void> updateIngredient(PantryIngredient ingredient) async {}

  @override
  Future<void> deleteIngredient(String id) async {}

  @override
  Future<void> bulkUpdateIngredients(BulkIngredientUpdate update) async {
    lastUpdate = update;
  }

  @override
  Future<List<IngredientCategory>> listCategories() async => [];

  @override
  Future<void> saveCategory(IngredientCategory category) async {}

  @override
  Future<List<PantryIngredient>> recoverCorruptedEntries() async => [];
}

void main() {
  test('BulkUpdateIngredients forwards update to repository', () async {
    final repo = _FakeIngredientRepository();
    final usecase = BulkUpdateIngredients(repo);
    final update = BulkIngredientUpdate(
      ingredientIds: const ['a', 'b'],
      quantityMode: BulkQuantityMode.adjust,
      quantityValue: -1,
      inventoryState: IngredientInventoryState.used,
      appliedAt: DateTime(2024, 1, 1),
    );

    await usecase(update);

    expect(repo.lastUpdate, isNotNull);
    expect(repo.lastUpdate!.ingredientIds.length, 2);
    expect(repo.lastUpdate!.quantityMode, BulkQuantityMode.adjust);
  });
}
