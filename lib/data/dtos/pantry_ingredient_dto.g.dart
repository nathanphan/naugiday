// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_ingredient_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PantryIngredientDto _$PantryIngredientDtoFromJson(Map<String, dynamic> json) =>
    PantryIngredientDto(
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
      inventoryState: json['inventoryState'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PantryIngredientDtoToJson(
  PantryIngredientDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'freshnessOverride': instance.freshnessOverride,
  'inventoryState': instance.inventoryState,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
