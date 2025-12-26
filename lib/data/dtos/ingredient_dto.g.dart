// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientDto _$IngredientDtoFromJson(Map<String, dynamic> json) =>
    IngredientDto(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      category: json['category'] as String?,
      quantityValue: (json['quantityValue'] as num?)?.toDouble(),
      quantityUnit: json['quantityUnit'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$IngredientDtoToJson(IngredientDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'category': instance.category,
      'quantityValue': instance.quantityValue,
      'quantityUnit': instance.quantityUnit,
      'notes': instance.notes,
    };
