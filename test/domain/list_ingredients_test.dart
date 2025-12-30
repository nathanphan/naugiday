import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:naugiday/domain/usecases/list_ingredients.dart';

class _FakeIngredientRepository implements IngredientRepository {
  _FakeIngredientRepository(this.items);

  final List<PantryIngredient> items;
  int listCalls = 0;

  @override
  Future<List<PantryIngredient>> listIngredients() async {
    listCalls += 1;
    return items;
  }

  @override
  Future<PantryIngredient?> getIngredient(String id) async => null;

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

PantryIngredient _ingredient(String name) => PantryIngredient(
      id: name.toLowerCase(),
      name: name,
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
  test('ListIngredients returns repository results', () async {
    final repo = _FakeIngredientRepository(
      [_ingredient('Milk'), _ingredient('Eggs')],
    );
    final usecase = ListIngredients(repo);

    final result = await usecase();

    expect(result.length, 2);
    expect(result.first.name, 'Milk');
    expect(repo.listCalls, 1);
  });
}
