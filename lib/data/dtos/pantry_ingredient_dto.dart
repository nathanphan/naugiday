import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/data/dtos/ingredient_photo_dto.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';

part 'pantry_ingredient_dto.g.dart';

@JsonSerializable()
class PantryIngredientDto {
  final String id;
  final String name;
  final String categoryId;
  final String? categoryName;
  final double quantity;
  final String unit;
  final DateTime? expiryDate;
  final bool? freshnessOverride;
  final String inventoryState;
  @JsonKey(defaultValue: <IngredientPhotoDto>[])
  final List<IngredientPhotoDto> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  PantryIngredientDto({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    required this.quantity,
    required this.unit,
    this.expiryDate,
    this.freshnessOverride,
    required this.inventoryState,
    this.photos = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PantryIngredientDto.fromDomain(PantryIngredient ingredient) {
    return PantryIngredientDto(
      id: ingredient.id,
      name: ingredient.name,
      categoryId: ingredient.categoryId,
      categoryName: ingredient.categoryName,
      quantity: ingredient.quantity,
      unit: ingredient.unit,
      expiryDate: ingredient.expiryDate,
      freshnessOverride: ingredient.freshnessOverride,
      inventoryState: ingredient.inventoryState.name,
      photos: ingredient.photos
          .map(IngredientPhotoDto.fromDomain)
          .toList(growable: false),
      createdAt: ingredient.createdAt,
      updatedAt: ingredient.updatedAt,
    );
  }

  PantryIngredient toDomain() {
    final inventory = IngredientInventoryState.values.firstWhere(
      (state) => state.name == inventoryState,
      orElse: () => IngredientInventoryState.inStock,
    );
    return PantryIngredient(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      freshnessOverride: freshnessOverride,
      inventoryState: inventory,
      photos: photos.map((photo) => photo.toDomain()).toList(growable: false),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PantryIngredientDto.fromJson(Map<String, dynamic> json) =>
      _$PantryIngredientDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PantryIngredientDtoToJson(this);
}
