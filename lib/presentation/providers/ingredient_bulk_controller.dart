import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_bulk_controller.g.dart';

class IngredientBulkState {
  final Set<String> selectedIds;
  final BulkQuantityMode quantityMode;
  final String quantityText;
  final IngredientInventoryState? inventoryState;
  final String? error;

  const IngredientBulkState({
    this.selectedIds = const {},
    this.quantityMode = BulkQuantityMode.none,
    this.quantityText = '',
    this.inventoryState,
    this.error,
  });

  IngredientBulkState copyWith({
    Set<String>? selectedIds,
    BulkQuantityMode? quantityMode,
    String? quantityText,
    IngredientInventoryState? inventoryState,
    String? error,
  }) {
    return IngredientBulkState(
      selectedIds: selectedIds ?? this.selectedIds,
      quantityMode: quantityMode ?? this.quantityMode,
      quantityText: quantityText ?? this.quantityText,
      inventoryState: inventoryState ?? this.inventoryState,
      error: error,
    );
  }
}

@riverpod
class IngredientBulkController extends _$IngredientBulkController {
  @override
  IngredientBulkState build() => const IngredientBulkState();

  void toggleSelection(String id) {
    final updated = state.selectedIds.toSet();
    if (!updated.add(id)) {
      updated.remove(id);
    }
    state = state.copyWith(selectedIds: updated, error: null);
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: {}, error: null);
  }

  void setQuantityMode(BulkQuantityMode mode) {
    state = state.copyWith(quantityMode: mode, error: null);
  }

  void setQuantityText(String value) {
    state = state.copyWith(quantityText: value, error: null);
  }

  void setInventoryState(IngredientInventoryState? value) {
    state = state.copyWith(inventoryState: value, error: null);
  }

  BulkIngredientUpdate? buildUpdate() {
    if (state.selectedIds.isEmpty) {
      state = state.copyWith(error: 'Select at least one ingredient');
      return null;
    }
    double? quantityValue;
    if (state.quantityMode != BulkQuantityMode.none) {
      quantityValue = double.tryParse(state.quantityText.trim());
      if (quantityValue == null) {
        state = state.copyWith(error: 'Enter a valid quantity');
        return null;
      }
      if (state.quantityMode == BulkQuantityMode.set && quantityValue <= 0) {
        state = state.copyWith(error: 'Quantity must be greater than zero');
        return null;
      }
      if (state.quantityMode == BulkQuantityMode.adjust && quantityValue == 0) {
        state = state.copyWith(error: 'Adjustment cannot be zero');
        return null;
      }
    }
    return BulkIngredientUpdate(
      ingredientIds: state.selectedIds.toList(),
      quantityMode: state.quantityMode,
      quantityValue: quantityValue,
      inventoryState: state.inventoryState,
      appliedAt: DateTime.now(),
    );
  }
}
