import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/cooking_step.dart';

part 'cooking_step_dto.g.dart';

@JsonSerializable()
class CookingStepDto {
  final String id;
  final int position;
  final String instruction;

  CookingStepDto({
    required this.id,
    required this.position,
    required this.instruction,
  });

  factory CookingStepDto.fromDomain(CookingStep step) => CookingStepDto(
        id: step.id,
        position: step.position,
        instruction: step.instruction,
      );

  CookingStep toDomain() => CookingStep(
        id: id,
        position: position,
        instruction: instruction,
      );

  factory CookingStepDto.fromJson(Map<String, dynamic> json) =>
      _$CookingStepDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CookingStepDtoToJson(this);
}
