import 'package:freezed_annotation/freezed_annotation.dart';

part 'cooking_step.freezed.dart';
part 'cooking_step.g.dart';

@freezed
abstract class CookingStep with _$CookingStep {
  const CookingStep._();

  const factory CookingStep({
    required String id,
    required int position,
    required String instruction,
  }) = _CookingStep;

  bool get isValid => instruction.trim().isNotEmpty && position > 0;

  factory CookingStep.fromJson(Map<String, dynamic> json) =>
      _$CookingStepFromJson(json);
}
