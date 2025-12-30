import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/dtos/ingredient_photo_dto.dart';
import 'package:naugiday/data/dtos/pantry_ingredient_dto.dart';
import 'package:naugiday/data/repositories/local_ingredient_repository.dart';

class _InMemoryIngredientsStore implements IngredientsStore {
  final Map<dynamic, dynamic> raw = {};

  @override
  bool get isEmpty => raw.isEmpty;

  @override
  Map<dynamic, dynamic> toMap() => Map.unmodifiable(raw);

  @override
  Iterable<PantryIngredientDto> get values =>
      raw.values.whereType<PantryIngredientDto>();

  @override
  PantryIngredientDto? get(dynamic key) => raw[key] as PantryIngredientDto?;

  @override
  Future<void> put(key, PantryIngredientDto value) async {
    raw[key] = value;
  }

  @override
  Future<void> delete(key) async {
    raw.remove(key);
  }

  @override
  Future<void> flush() async {}
}

PantryIngredientDto _legacyDto() {
  return PantryIngredientDto(
    id: 'legacy-id',
    name: 'Legacy Ingredient',
    categoryId: 'fridge',
    categoryName: 'Fridge',
    quantity: 1,
    unit: 'pcs',
    inventoryState: 'inStock',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
    photos: const [],
  );
}

void main() {
  test('legacy ingredients default to empty photo list', () async {
    final store = _InMemoryIngredientsStore();
    store.raw['legacy-id'] = _legacyDto();

    final repo = LocalIngredientRepository(ingredientsStore: store);
    final ingredients = await repo.listIngredients();

    expect(ingredients, isNotEmpty);
    expect(ingredients.first.photos, isEmpty);
  });

  test('stored photo references are preserved', () async {
    final store = _InMemoryIngredientsStore();
    store.raw['photo-id'] = PantryIngredientDto(
      id: 'photo-id',
      name: 'Photo Ingredient',
      categoryId: 'fridge',
      categoryName: 'Fridge',
      quantity: 1,
      unit: 'pcs',
      inventoryState: 'inStock',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
      photos: [
        IngredientPhotoDto(
          id: 'p1',
          path: '/tmp/p1.jpg',
          source: 'gallery',
          displayOrder: 0,
          createdAt: DateTime(2024, 1, 1),
        ),
      ],
    );

    final repo = LocalIngredientRepository(ingredientsStore: store);
    final ingredients = await repo.listIngredients();

    expect(ingredients.first.photos, hasLength(1));
    expect(ingredients.first.photos.first.id, 'p1');
  });
}
