import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';

part 'recipe_image_dto.g.dart';

@JsonSerializable()
class RecipeImageDto {
  final String id;
  final String localPath;
  final String fileName;
  final int fileSizeBytes;
  final DateTime? addedAt;

  RecipeImageDto({
    required this.id,
    required this.localPath,
    required this.fileName,
    required this.fileSizeBytes,
    this.addedAt,
  });

  factory RecipeImageDto.fromDomain(RecipeImage image) => RecipeImageDto(
        id: image.id,
        localPath: image.localPath,
        fileName: image.fileName,
        fileSizeBytes: image.fileSizeBytes,
        addedAt: image.addedAt,
      );

  RecipeImage toDomain() => RecipeImage(
        id: id,
        localPath: localPath,
        fileName: fileName,
        fileSizeBytes: fileSizeBytes,
        addedAt: addedAt,
      );

  factory RecipeImageDto.fromJson(Map<String, dynamic> json) =>
      _$RecipeImageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeImageDtoToJson(this);
}
