// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PantryIngredient _$PantryIngredientFromJson(Map<String, dynamic> json) =>
    _PantryIngredient(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      freshnessOverride: json['freshnessOverride'] as bool?,
      inventoryState: $enumDecode(
        _$IngredientInventoryStateEnumMap,
        json['inventoryState'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PantryIngredientToJson(
  _PantryIngredient instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'freshnessOverride': instance.freshnessOverride,
  'inventoryState': _$IngredientInventoryStateEnumMap[instance.inventoryState]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$IngredientInventoryStateEnumMap = {
  IngredientInventoryState.inStock: 'inStock',
  IngredientInventoryState.used: 'used',
  IngredientInventoryState.bought: 'bought',
};
