import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/usecases/validate_ingredient.dart';

PantryIngredient _ingredient({
  List<IngredientPhoto> photos = const [],
}) {
  return PantryIngredient(
    id: 'i1',
    name: 'Tomatoes',
    categoryId: 'fridge',
    categoryName: 'Fridge',
    quantity: 1,
    unit: 'pcs',
    inventoryState: IngredientInventoryState.inStock,
    photos: photos,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );
}

IngredientPhoto _photo(int index, {String? path}) {
  return IngredientPhoto(
    id: 'p$index',
    path: path ?? '/tmp/p$index.jpg',
    source: IngredientPhotoSource.gallery,
    displayOrder: index,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  test('ValidateIngredient blocks photo counts above limit', () {
    final photos = List.generate(
      maxIngredientPhotos + 1,
      (index) => _photo(index),
    );
    final ingredient = _ingredient(photos: photos);

    final result = ValidateIngredient()(ingredient);

    expect(result.isValid, isFalse);
    expect(result.errors, contains('You can add up to $maxIngredientPhotos photos'));
  });

  test('ValidateIngredient flags missing photo paths', () {
    final ingredient = _ingredient(photos: [_photo(1, path: '')]);

    final result = ValidateIngredient()(ingredient);

    expect(result.isValid, isFalse);
    expect(result.errors, contains('Remove or reselect missing photos'));
  });
}
