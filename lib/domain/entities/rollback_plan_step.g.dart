// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rollback_plan_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RollbackPlanStep _$RollbackPlanStepFromJson(Map<String, dynamic> json) =>
    _RollbackPlanStep(
      id: json['id'] as String,
      action: json['action'] as String,
      trigger: json['trigger'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$RollbackPlanStepToJson(_RollbackPlanStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'trigger': instance.trigger,
      'status': instance.status,
    };
