import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/usecases/validate_ingredient.dart';

PantryIngredient _ingredient({
  String id = 'i1',
  String name = 'Milk',
  String categoryId = 'fridge',
  String? categoryName = 'Fridge',
  double quantity = 1,
  String unit = 'pcs',
  DateTime? expiryDate,
  bool? freshnessOverride = true,
}) {
  return PantryIngredient(
    id: id,
    name: name,
    categoryId: categoryId,
    categoryName: categoryName,
    quantity: quantity,
    unit: unit,
    expiryDate: expiryDate,
    freshnessOverride: freshnessOverride,
    inventoryState: IngredientInventoryState.inStock,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );
}

void main() {
  test('ValidateIngredient rejects missing fields', () {
    final ingredient = _ingredient(
      name: '',
      categoryId: '',
      unit: '',
      quantity: 0,
    );

    final result = ValidateIngredient()(ingredient);

    expect(result.isValid, isFalse);
    expect(result.errors, contains('Name is required'));
    expect(result.errors, contains('Category is required'));
    expect(result.errors, contains('Unit is required'));
    expect(result.errors, contains('Quantity must be greater than zero'));
  });

  test('ValidateIngredient blocks past expiry dates', () {
    final ingredient = _ingredient(
      expiryDate: DateTime.now().subtract(const Duration(days: 1)),
    );

    final result = ValidateIngredient()(ingredient);

    expect(result.isValid, isFalse);
    expect(result.errors, contains('Expiry date cannot be in the past'));
  });

  test('ValidateIngredient flags duplicates', () {
    final ingredient = _ingredient(name: 'Milk');
    final existing = [
      _ingredient(id: 'i2', name: 'Milk'),
    ];

    final result = ValidateIngredient()(ingredient, existing: existing);

    expect(result.isValid, isTrue);
    expect(result.hasDuplicate, isTrue);
  });
}
