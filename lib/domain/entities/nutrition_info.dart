import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_info.freezed.dart';

@freezed
class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) = _NutritionInfo;
}
