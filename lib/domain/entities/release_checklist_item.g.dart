// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReleaseChecklistItem _$ReleaseChecklistItemFromJson(
  Map<String, dynamic> json,
) => _ReleaseChecklistItem(
  id: json['id'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  owner: json['owner'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ReleaseChecklistItemToJson(
  _ReleaseChecklistItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': instance.status,
  'owner': instance.owner,
  'notes': instance.notes,
};
