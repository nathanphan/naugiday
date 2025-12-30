import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';

part 'ingredient_category_dto.g.dart';

@JsonSerializable()
class IngredientCategoryDto {
  final String id;
  final String name;
  final bool isCustom;
  final DateTime createdAt;

  IngredientCategoryDto({
    required this.id,
    required this.name,
    required this.isCustom,
    required this.createdAt,
  });

  factory IngredientCategoryDto.fromDomain(IngredientCategory category) {
    return IngredientCategoryDto(
      id: category.id,
      name: category.name,
      isCustom: category.isCustom,
      createdAt: category.createdAt,
    );
  }

  IngredientCategory toDomain() {
    return IngredientCategory(
      id: id,
      name: name,
      isCustom: isCustom,
      createdAt: createdAt,
    );
  }

  factory IngredientCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$IngredientCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientCategoryDtoToJson(this);
}
