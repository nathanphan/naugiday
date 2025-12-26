// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  id: json['id'] as String,
  name: json['name'] as String,
  quantity: json['quantity'] as String,
  quantityValue: (json['quantityValue'] as num?)?.toDouble(),
  quantityUnit: json['quantityUnit'] as String?,
  category: json['category'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'quantityValue': instance.quantityValue,
      'quantityUnit': instance.quantityUnit,
      'category': instance.category,
      'notes': instance.notes,
    };
