// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CookingStep _$CookingStepFromJson(Map<String, dynamic> json) => _CookingStep(
  id: json['id'] as String,
  position: (json['position'] as num).toInt(),
  instruction: json['instruction'] as String,
);

Map<String, dynamic> _$CookingStepToJson(_CookingStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'instruction': instance.instruction,
    };
