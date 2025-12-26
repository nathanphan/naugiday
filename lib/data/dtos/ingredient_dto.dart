import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/ingredient.dart';

part 'ingredient_dto.g.dart';

@JsonSerializable()
class IngredientDto {
  final String id;
  final String name;
  final String quantity;
  final String? category;
  final double? quantityValue;
  final String? quantityUnit;
  final String? notes;

  IngredientDto({
    required this.id,
    required this.name,
    required this.quantity,
    this.category,
    this.quantityValue,
    this.quantityUnit,
    this.notes,
  });

  factory IngredientDto.fromDomain(Ingredient ingredient) {
    return IngredientDto(
      id: ingredient.id,
      name: ingredient.name,
      quantity: ingredient.quantity,
      category: ingredient.category,
      quantityValue: ingredient.quantityValue,
      quantityUnit: ingredient.quantityUnit,
      notes: ingredient.notes,
    );
  }

  Ingredient toDomain() {
    return Ingredient(
      id: id,
      name: name,
      quantity: quantity,
      category: category,
      quantityValue: quantityValue,
      quantityUnit: quantityUnit,
      notes: notes,
    );
  }

  factory IngredientDto.fromJson(Map<String, dynamic> json) =>
      _$IngredientDtoFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientDtoToJson(this);
}
