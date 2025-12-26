// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_step_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookingStepDto _$CookingStepDtoFromJson(Map<String, dynamic> json) =>
    CookingStepDto(
      id: json['id'] as String,
      position: (json['position'] as num).toInt(),
      instruction: json['instruction'] as String,
    );

Map<String, dynamic> _$CookingStepDtoToJson(CookingStepDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'instruction': instance.instruction,
    };
