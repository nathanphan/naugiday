// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_disclosure_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivacyDisclosureItem _$PrivacyDisclosureItemFromJson(
  Map<String, dynamic> json,
) => _PrivacyDisclosureItem(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  status: json['status'] as String,
  lastVerifiedAt: json['lastVerifiedAt'] == null
      ? null
      : DateTime.parse(json['lastVerifiedAt'] as String),
);

Map<String, dynamic> _$PrivacyDisclosureItemToJson(
  _PrivacyDisclosureItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'lastVerifiedAt': instance.lastVerifiedAt?.toIso8601String(),
};
