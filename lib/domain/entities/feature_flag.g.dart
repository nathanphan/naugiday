// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeatureFlag _$FeatureFlagFromJson(Map<String, dynamic> json) => _FeatureFlag(
  name: json['name'] as String,
  enabled: json['enabled'] as bool,
  source: json['source'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FeatureFlagToJson(_FeatureFlag instance) =>
    <String, dynamic>{
      'name': instance.name,
      'enabled': instance.enabled,
      'source': instance.source,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
