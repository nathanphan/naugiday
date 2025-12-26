import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_image.freezed.dart';
part 'recipe_image.g.dart';

@freezed
abstract class RecipeImage with _$RecipeImage {
  const RecipeImage._();

  const factory RecipeImage({
    required String id,
    required String localPath,
    required String fileName,
    required int fileSizeBytes,
    DateTime? addedAt,
  }) = _RecipeImage;

  bool get isValid => localPath.isNotEmpty && fileSizeBytes > 0;

  factory RecipeImage.fromJson(Map<String, dynamic> json) =>
      _$RecipeImageFromJson(json);
}
