import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';

part 'pantry_ingredient.freezed.dart';
part 'pantry_ingredient.g.dart';

enum IngredientInventoryState { inStock, used, bought }

enum FreshnessStatus { fresh, stale, unknown }

@freezed
abstract class PantryIngredient with _$PantryIngredient {
  const PantryIngredient._();

  const factory PantryIngredient({
    required String id,
    required String name,
    required String categoryId,
    String? categoryName,
    required double quantity,
    required String unit,
    DateTime? expiryDate,
    bool? freshnessOverride,
    required IngredientInventoryState inventoryState,
    @Default(<IngredientPhoto>[]) List<IngredientPhoto> photos,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PantryIngredient;

  factory PantryIngredient.fromJson(Map<String, dynamic> json) =>
      _$PantryIngredientFromJson(json);

  FreshnessStatus get freshnessStatus {
    final expiryDate = this.expiryDate;
    if (expiryDate != null) {
      return expiryDate.isBefore(DateTime.now())
          ? FreshnessStatus.stale
          : FreshnessStatus.fresh;
    }
    final override = freshnessOverride;
    if (override == null) return FreshnessStatus.unknown;
    return override ? FreshnessStatus.fresh : FreshnessStatus.stale;
  }
}
