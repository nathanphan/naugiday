import 'package:freezed_annotation/freezed_annotation.dart';

part 'rollback_plan_step.freezed.dart';
part 'rollback_plan_step.g.dart';

@freezed
abstract class RollbackPlanStep with _$RollbackPlanStep {
  const RollbackPlanStep._();

  const factory RollbackPlanStep({
    required String id,
    required String action,
    required String trigger,
    required String status,
  }) = _RollbackPlanStep;

  factory RollbackPlanStep.fromJson(Map<String, dynamic> json) =>
      _$RollbackPlanStepFromJson(json);
}
