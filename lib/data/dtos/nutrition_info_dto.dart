import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';

part 'nutrition_info_dto.g.dart';

@JsonSerializable()
class NutritionInfoDto {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  NutritionInfoDto({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionInfoDto.fromDomain(NutritionInfo info) {
    return NutritionInfoDto(
      calories: info.calories,
      protein: info.protein,
      carbs: info.carbs,
      fat: info.fat,
    );
  }

  NutritionInfo toDomain() {
    return NutritionInfo(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }

  factory NutritionInfoDto.fromJson(Map<String, dynamic> json) => _$NutritionInfoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInfoDtoToJson(this);
}
