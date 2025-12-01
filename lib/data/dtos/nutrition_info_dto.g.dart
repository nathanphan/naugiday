// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionInfoDto _$NutritionInfoDtoFromJson(Map<String, dynamic> json) =>
    NutritionInfoDto(
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toInt(),
      carbs: (json['carbs'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
    );

Map<String, dynamic> _$NutritionInfoDtoToJson(NutritionInfoDto instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };
