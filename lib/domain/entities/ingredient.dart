import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@freezed
abstract class Ingredient with _$Ingredient {
  const Ingredient._();

  const factory Ingredient({
    required String id,
    required String name,
    required String quantity,
    double? quantityValue,
    String? quantityUnit,
    String? category,
    String? notes,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
