import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/ingredient.dart';

part 'ingredient_dto.g.dart';

@JsonSerializable()
class IngredientDto {
  final String id;
  final String name;
  final String quantity;
  final String? category;

  IngredientDto({
    required this.id,
    required this.name,
    required this.quantity,
    this.category,
  });

  factory IngredientDto.fromDomain(Ingredient ingredient) {
    return IngredientDto(
      id: ingredient.id,
      name: ingredient.name,
      quantity: ingredient.quantity,
      category: ingredient.category,
    );
  }

  Ingredient toDomain() {
    return Ingredient(
      id: id,
      name: name,
      quantity: quantity,
      category: category,
    );
  }

  factory IngredientDto.fromJson(Map<String, dynamic> json) =>
      _$IngredientDtoFromJson(json);
  Map<String, dynamic> toJson() => _$IngredientDtoToJson(this);
}
