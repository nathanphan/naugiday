import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';

part 'ingredient_photo_dto.g.dart';

@JsonSerializable()
class IngredientPhotoDto {
  final String id;
  final String path;
  final String source;
  final int displayOrder;
  final DateTime createdAt;

  IngredientPhotoDto({
    required this.id,
    required this.path,
    required this.source,
    required this.displayOrder,
    required this.createdAt,
  });

  factory IngredientPhotoDto.fromDomain(IngredientPhoto photo) {
    return IngredientPhotoDto(
      id: photo.id,
      path: photo.path,
      source: photo.source.name,
      displayOrder: photo.displayOrder,
      createdAt: photo.createdAt,
    );
  }

  IngredientPhoto toDomain() {
    final sourceValue = IngredientPhotoSource.values.firstWhere(
      (value) => value.name == source,
      orElse: () => IngredientPhotoSource.gallery,
    );
    return IngredientPhoto(
      id: id,
      path: path,
      source: sourceValue,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }

  factory IngredientPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$IngredientPhotoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientPhotoDtoToJson(this);
}
