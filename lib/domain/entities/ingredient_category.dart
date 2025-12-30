import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_category.freezed.dart';
part 'ingredient_category.g.dart';

@freezed
abstract class IngredientCategory with _$IngredientCategory {
  const IngredientCategory._();

  const factory IngredientCategory({
    required String id,
    required String name,
    required bool isCustom,
    required DateTime createdAt,
  }) = _IngredientCategory;

  factory IngredientCategory.fromJson(Map<String, dynamic> json) =>
      _$IngredientCategoryFromJson(json);
}
