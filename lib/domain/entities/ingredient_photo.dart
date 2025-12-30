import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_photo.freezed.dart';
part 'ingredient_photo.g.dart';

enum IngredientPhotoSource { camera, gallery }

@freezed
abstract class IngredientPhoto with _$IngredientPhoto {
  const IngredientPhoto._();

  const factory IngredientPhoto({
    required String id,
    required String path,
    required IngredientPhotoSource source,
    required int displayOrder,
    required DateTime createdAt,
  }) = _IngredientPhoto;

  factory IngredientPhoto.fromJson(Map<String, dynamic> json) =>
      _$IngredientPhotoFromJson(json);
}
