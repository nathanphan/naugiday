import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/data/dtos/ingredient_category_dto.dart';
import 'package:naugiday/data/dtos/pantry_ingredient_dto.dart';
import 'package:naugiday/data/local/hive_setup.dart';
import 'package:naugiday/data/services/ingredient_photo_storage.dart';
import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/errors/ingredient_storage_exception.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:uuid/uuid.dart';

class LocalIngredientRepository implements IngredientRepository {
  LocalIngredientRepository({
    IngredientsStore? ingredientsStore,
    IngredientCategoriesStore? categoriesStore,
    IngredientPhotoStorage? photoStorage,
  })  : _ingredientsStoreOverride = ingredientsStore,
        _categoriesStoreOverride = categoriesStore,
        _photoStorage = photoStorage ?? IngredientPhotoStorage();

  final IngredientsStore? _ingredientsStoreOverride;
  final IngredientCategoriesStore? _categoriesStoreOverride;
  final IngredientPhotoStorage _photoStorage;

  Future<IngredientsStore> _getIngredientsStore() async {
    final override = _ingredientsStoreOverride;
    if (override != null) {
      return override;
    }
    if (!Hive.isBoxOpen(pantryIngredientsBoxName)) {
      await initHiveForRecipes();
    }
    final Box box = Hive.box(pantryIngredientsBoxName);
    return HiveIngredientsStore(box);
  }

  Future<IngredientCategoriesStore> _getCategoriesStore() async {
    final override = _categoriesStoreOverride;
    if (override != null) {
      await _ensureDefaultCategories(override);
      return override;
    }
    if (!Hive.isBoxOpen(ingredientCategoriesBoxName)) {
      await initHiveForRecipes();
    }
    final Box box = Hive.box(ingredientCategoriesBoxName);
    final store = HiveIngredientCategoriesStore(box);
    await _ensureDefaultCategories(store);
    return store;
  }

  Future<void> _ensureDefaultCategories(IngredientCategoriesStore store) async {
    if (store.isEmpty) {
      final now = DateTime.now();
      for (final name in defaultIngredientCategories) {
        final category = IngredientCategoryDto(
          id: const Uuid().v4(),
          name: name,
          isCustom: false,
          createdAt: now,
        );
        await store.put(category.id, category);
      }
      await store.flush();
    }
  }

  bool _isValidIngredientDto(Object? value) {
    if (value is! PantryIngredientDto) return false;
    if (value.id.isEmpty || value.name.trim().isEmpty) return false;
    if (value.categoryId.isEmpty || value.unit.trim().isEmpty) return false;
    if (value.quantity <= 0) return false;
    if (value.photos.length > maxIngredientPhotos) return false;
    return true;
  }

  Future<List<PantryIngredient>> _readValidated(
    IngredientsStore store,
  ) async {
    final entries = store.toMap();
    final ingredients = <PantryIngredient>[];
    final corruptedKeys = <dynamic>[];
    for (final entry in entries.entries) {
      final value = entry.value;
      try {
        if (!_isValidIngredientDto(value)) {
          corruptedKeys.add(entry.key);
          continue;
        }
        ingredients.add((value as PantryIngredientDto).toDomain());
      } catch (_) {
        corruptedKeys.add(entry.key);
      }
    }
    if (corruptedKeys.isNotEmpty) {
      throw IngredientStorageException.corrupted(corruptedKeys);
    }
    ingredients.sort(
      (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );
    return ingredients;
  }

  Future<void> _safeWrite(
    Future<void> Function(IngredientsStore store) writer,
  ) async {
    final store = await _getIngredientsStore();
    try {
      await writer(store);
    } catch (err) {
      if (err is IngredientStorageException) rethrow;
      throw IngredientStorageException.write(err);
    }
  }

  @override
  Future<List<PantryIngredient>> listIngredients() async {
    final store = await _getIngredientsStore();
    try {
      return await _readValidated(store);
    } catch (err) {
      if (err is IngredientStorageException) rethrow;
      throw IngredientStorageException.read(err);
    }
  }

  @override
  Future<PantryIngredient?> getIngredient(String id) async {
    final store = await _getIngredientsStore();
    final value = store.get(id);
    if (!_isValidIngredientDto(value)) return null;
    return (value as PantryIngredientDto).toDomain();
  }

  @override
  Future<void> saveIngredient(PantryIngredient ingredient) async {
    await _safeWrite((store) async {
      final persistedPhotos = await _photoStorage.persistAll(ingredient.photos);
      final next = ingredient.copyWith(photos: persistedPhotos);
      final dto = PantryIngredientDto.fromDomain(next);
      await store.put(dto.id, dto);
    });
  }

  @override
  Future<void> updateIngredient(PantryIngredient ingredient) async {
    await _safeWrite((store) async {
      PantryIngredient? existing;
      final stored = store.get(ingredient.id);
      if (_isValidIngredientDto(stored)) {
        existing = (stored as PantryIngredientDto).toDomain();
      }
      final persistedPhotos = await _photoStorage.persistAll(ingredient.photos);
      if (existing != null) {
        await _photoStorage.deleteRemoved(
          existing: existing.photos,
          updated: persistedPhotos,
        );
      }
      final next = ingredient.copyWith(photos: persistedPhotos);
      final dto = PantryIngredientDto.fromDomain(next);
      await store.put(dto.id, dto);
    });
  }

  @override
  Future<void> deleteIngredient(String id) async {
    await _safeWrite((store) async {
      final stored = store.get(id);
      if (_isValidIngredientDto(stored)) {
        final ingredient = (stored as PantryIngredientDto).toDomain();
        for (final photo in ingredient.photos) {
          await _photoStorage.deleteIfManaged(photo.path);
        }
      }
      await store.delete(id);
    });
  }

  @override
  Future<void> bulkUpdateIngredients(BulkIngredientUpdate update) async {
    await _safeWrite((store) async {
      for (final id in update.ingredientIds) {
        final value = store.get(id);
        if (!_isValidIngredientDto(value)) continue;
        var ingredient = (value as PantryIngredientDto).toDomain();
        if (update.quantityMode == BulkQuantityMode.set) {
          final next = update.quantityValue ?? ingredient.quantity;
          if (next <= 0) {
            throw IngredientStorageException.write(
              'Bulk quantity must be greater than zero',
            );
          }
          ingredient = ingredient.copyWith(quantity: next);
        } else if (update.quantityMode == BulkQuantityMode.adjust) {
          final delta = update.quantityValue ?? 0;
          final next = ingredient.quantity + delta;
          if (next <= 0) {
            throw IngredientStorageException.write(
              'Bulk quantity must be greater than zero',
            );
          }
          ingredient = ingredient.copyWith(quantity: next);
        }
        final status = update.inventoryState;
        if (status != null) {
          ingredient = ingredient.copyWith(inventoryState: status);
        }
        ingredient = ingredient.copyWith(updatedAt: update.appliedAt);
        await store.put(id, PantryIngredientDto.fromDomain(ingredient));
      }
    });
  }

  @override
  Future<List<IngredientCategory>> listCategories() async {
    final store = await _getCategoriesStore();
    final categories =
        store.values.map((dto) => dto.toDomain()).toList(growable: false);
    categories.sort((a, b) => a.name.compareTo(b.name));
    return categories;
  }

  @override
  Future<void> saveCategory(IngredientCategory category) async {
    final store = await _getCategoriesStore();
    await store.put(category.id, IngredientCategoryDto.fromDomain(category));
    await store.flush();
  }

  @override
  Future<List<PantryIngredient>> recoverCorruptedEntries() async {
    final store = await _getIngredientsStore();
    final entries = store.toMap();
    final corruptedKeys = <dynamic>[];
    for (final entry in entries.entries) {
      if (!_isValidIngredientDto(entry.value)) {
        corruptedKeys.add(entry.key);
      }
    }
    for (final key in corruptedKeys) {
      await store.delete(key);
    }
    await store.flush();
    return _readValidated(store);
  }
}

abstract class IngredientsStore {
  bool get isEmpty;
  Map<dynamic, dynamic> toMap();
  Iterable<PantryIngredientDto> get values;
  PantryIngredientDto? get(dynamic key);
  Future<void> put(dynamic key, PantryIngredientDto value);
  Future<void> delete(dynamic key);
  Future<void> flush();
}

class HiveIngredientsStore implements IngredientsStore {
  HiveIngredientsStore(this._box);

  final Box _box;

  @override
  bool get isEmpty => _box.isEmpty;

  @override
  Map<dynamic, dynamic> toMap() => _box.toMap();

  @override
  Iterable<PantryIngredientDto> get values =>
      _box.values.whereType<PantryIngredientDto>();

  @override
  PantryIngredientDto? get(key) => _box.get(key) as PantryIngredientDto?;

  @override
  Future<void> put(key, PantryIngredientDto value) => _box.put(key, value);

  @override
  Future<void> delete(key) => _box.delete(key);

  @override
  Future<void> flush() => _box.flush();
}

abstract class IngredientCategoriesStore {
  bool get isEmpty;
  Iterable<IngredientCategoryDto> get values;
  Future<void> put(dynamic key, IngredientCategoryDto value);
  Future<void> flush();
}

class HiveIngredientCategoriesStore implements IngredientCategoriesStore {
  HiveIngredientCategoriesStore(this._box);

  final Box _box;

  @override
  bool get isEmpty => _box.isEmpty;

  @override
  Iterable<IngredientCategoryDto> get values =>
      _box.values.whereType<IngredientCategoryDto>();

  @override
  Future<void> put(key, IngredientCategoryDto value) => _box.put(key, value);

  @override
  Future<void> flush() => _box.flush();
}
