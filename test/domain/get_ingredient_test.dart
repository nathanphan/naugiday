import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:naugiday/domain/usecases/get_ingredient.dart';

class _FakeIngredientRepository implements IngredientRepository {
  _FakeIngredientRepository(this.items);

  final Map<String, PantryIngredient> items;

  @override
  Future<List<PantryIngredient>> listIngredients() async => items.values.toList();

  @override
  Future<PantryIngredient?> getIngredient(String id) async => items[id];

  @override
  Future<void> saveIngredient(PantryIngredient ingredient) async {}

  @override
  Future<void> updateIngredient(PantryIngredient ingredient) async {}

  @override
  Future<void> deleteIngredient(String id) async {}

  @override
  Future<void> bulkUpdateIngredients(BulkIngredientUpdate update) async {}

  @override
  Future<List<IngredientCategory>> listCategories() async => [];

  @override
  Future<void> saveCategory(IngredientCategory category) async {}

  @override
  Future<List<PantryIngredient>> recoverCorruptedEntries() async => [];
}

PantryIngredient _ingredient(String id) => PantryIngredient(
      id: id,
      name: 'Ingredient $id',
      categoryId: 'fridge',
      categoryName: 'Fridge',
      quantity: 1,
      unit: 'pcs',
      expiryDate: null,
      freshnessOverride: true,
      inventoryState: IngredientInventoryState.inStock,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    );

void main() {
  test('GetIngredient returns matching item', () async {
    final repo = _FakeIngredientRepository({'a': _ingredient('a')});
    final usecase = GetIngredient(repo);

    final result = await usecase('a');

    expect(result, isNotNull);
    expect(result!.id, 'a');
  });

  test('GetIngredient returns null when missing', () async {
    final repo = _FakeIngredientRepository({});
    final usecase = GetIngredient(repo);

    final result = await usecase('missing');

    expect(result, isNull);
  });
}
