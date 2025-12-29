import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flag.freezed.dart';
part 'feature_flag.g.dart';

@freezed
abstract class FeatureFlag with _$FeatureFlag {
  const FeatureFlag._();

  const factory FeatureFlag({
    required String name,
    required bool enabled,
    required String source,
    required DateTime updatedAt,
  }) = _FeatureFlag;

  factory FeatureFlag.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagFromJson(json);
}
