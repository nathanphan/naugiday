import 'package:naugiday/domain/entities/pantry_ingredient.dart';

enum BulkQuantityMode { set, adjust, none }

class BulkIngredientUpdate {
  final List<String> ingredientIds;
  final BulkQuantityMode quantityMode;
  final double? quantityValue;
  final IngredientInventoryState? inventoryState;
  final DateTime appliedAt;

  const BulkIngredientUpdate({
    required this.ingredientIds,
    required this.quantityMode,
    this.quantityValue,
    this.inventoryState,
    required this.appliedAt,
  });
}
