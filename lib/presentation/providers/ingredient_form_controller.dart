import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/usecases/validate_ingredient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_form_controller.g.dart';

const _noChange = Object();

class IngredientFormState {
  final String name;
  final String categoryId;
  final String? categoryName;
  final String quantityText;
  final String unit;
  final DateTime? buyDate;
  final DateTime? expiryDate;
  final bool? freshnessOverride;
  final bool hasDuplicate;
  final List<IngredientPhoto> photos;
  final List<String> errors;

  const IngredientFormState({
    this.name = '',
    this.categoryId = '',
    this.categoryName,
    this.quantityText = '1',
    this.unit = 'pcs',
    this.buyDate,
    this.expiryDate,
    this.freshnessOverride = true,
    this.hasDuplicate = false,
    this.photos = const [],
    this.errors = const [],
  });

  IngredientFormState copyWith({
    String? name,
    String? categoryId,
    String? categoryName,
    String? quantityText,
    String? unit,
    Object? buyDate = _noChange,
    Object? expiryDate = _noChange,
    Object? freshnessOverride = _noChange,
    bool? hasDuplicate,
    List<IngredientPhoto>? photos,
    List<String>? errors,
  }) {
    return IngredientFormState(
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      quantityText: quantityText ?? this.quantityText,
      unit: unit ?? this.unit,
      buyDate: buyDate == _noChange ? this.buyDate : buyDate as DateTime?,
      expiryDate:
          expiryDate == _noChange ? this.expiryDate : expiryDate as DateTime?,
      freshnessOverride: freshnessOverride == _noChange
          ? this.freshnessOverride
          : freshnessOverride as bool?,
      hasDuplicate: hasDuplicate ?? this.hasDuplicate,
      photos: photos ?? this.photos,
      errors: errors ?? this.errors,
    );
  }
}

@riverpod
class IngredientFormController extends _$IngredientFormController {
  final ValidateIngredient _validate = ValidateIngredient();

  @override
  IngredientFormState build() => const IngredientFormState();

  void reset() {
    state = const IngredientFormState();
  }

  void loadIngredient(PantryIngredient ingredient) {
    final quantityText = ingredient.quantity % 1 == 0
        ? ingredient.quantity.toStringAsFixed(0)
        : ingredient.quantity.toString();
    final photos = [...ingredient.photos]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    state = IngredientFormState(
      name: ingredient.name,
      categoryId: ingredient.categoryId,
      categoryName: ingredient.categoryName,
      quantityText: quantityText,
      unit: ingredient.unit,
      buyDate: ingredient.createdAt,
      expiryDate: ingredient.expiryDate,
      freshnessOverride: ingredient.freshnessOverride,
      hasDuplicate: false,
      photos: photos,
      errors: const [],
    );
  }

  void setName(String value) {
    state = state.copyWith(name: value, errors: const []);
  }

  void setCategory(IngredientCategory category) {
    state = state.copyWith(
      categoryId: category.id,
      categoryName: category.name,
      errors: const [],
    );
  }

  void setQuantityText(String value) {
    state = state.copyWith(quantityText: value, errors: const []);
  }

  void setUnit(String value) {
    state = state.copyWith(unit: value, errors: const []);
  }

  void setBuyDate(DateTime? value) {
    state = state.copyWith(buyDate: value, errors: const []);
  }

  void setExpiryDate(DateTime? value) {
    final override =
        value == null ? (state.freshnessOverride ?? true) : null;
    state = state.copyWith(
      expiryDate: value,
      freshnessOverride: override,
      errors: const [],
    );
  }

  void setFreshnessOverride(bool? value) {
    state = state.copyWith(freshnessOverride: value, errors: const []);
  }

  void addPhoto(IngredientPhoto photo) {
    if (state.photos.length >= maxIngredientPhotos) {
      state = state.copyWith(
        errors: ['You can add up to $maxIngredientPhotos photos'],
      );
      return;
    }
    final updated = [...state.photos, photo];
    state = state.copyWith(
      photos: _normalizePhotos(updated),
      errors: const [],
    );
  }

  void removePhoto(String id) {
    final updated = state.photos.where((photo) => photo.id != id).toList();
    state = state.copyWith(
      photos: _normalizePhotos(updated),
      errors: const [],
    );
  }

  void adjustQuantity(double delta) {
    final current = double.tryParse(state.quantityText.trim()) ?? 0;
    final next = (current + delta).clamp(0, double.infinity);
    final text = next % 1 == 0
        ? next.toStringAsFixed(0)
        : next.toStringAsFixed(1);
    state = state.copyWith(quantityText: text, errors: const []);
  }

  IngredientValidationResult validate({
    required String ingredientId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Iterable<PantryIngredient> existing,
  }) {
    final quantity = double.tryParse(state.quantityText.trim()) ?? 0;
    final freshnessOverride =
        state.expiryDate == null ? state.freshnessOverride : null;
    final createdAtValue = state.buyDate ?? createdAt;
    final ingredient = PantryIngredient(
      id: ingredientId,
      name: state.name.trim(),
      categoryId: state.categoryId,
      categoryName: state.categoryName,
      quantity: quantity,
      unit: state.unit.trim(),
      expiryDate: state.expiryDate,
      freshnessOverride: freshnessOverride,
      inventoryState: IngredientInventoryState.inStock,
      photos: state.photos,
      createdAt: createdAtValue,
      updatedAt: updatedAt,
    );
    final result = _validate(ingredient, existing: existing);
    state = state.copyWith(
      errors: result.errors,
      hasDuplicate: result.hasDuplicate,
    );
    return result;
  }

  PantryIngredient buildIngredient({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required IngredientInventoryState inventoryState,
  }) {
    final quantity = double.tryParse(state.quantityText.trim()) ?? 0;
    final freshnessOverride =
        state.expiryDate == null ? state.freshnessOverride : null;
    final createdAtValue = state.buyDate ?? createdAt;
    return PantryIngredient(
      id: id,
      name: state.name.trim(),
      categoryId: state.categoryId,
      categoryName: state.categoryName,
      quantity: quantity,
      unit: state.unit.trim(),
      expiryDate: state.expiryDate,
      freshnessOverride: freshnessOverride,
      inventoryState: inventoryState,
      photos: state.photos,
      createdAt: createdAtValue,
      updatedAt: updatedAt,
    );
  }

  List<IngredientPhoto> _normalizePhotos(List<IngredientPhoto> photos) {
    return [
      for (var index = 0; index < photos.length; index += 1)
        photos[index].copyWith(displayOrder: index),
    ];
  }
}
