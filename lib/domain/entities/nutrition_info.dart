import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_info.freezed.dart';
part 'nutrition_info.g.dart';

@freezed
abstract class NutritionInfo with _$NutritionInfo {
  const NutritionInfo._();

  const factory NutritionInfo({
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}
