import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_checklist_item.freezed.dart';
part 'release_checklist_item.g.dart';

@freezed
abstract class ReleaseChecklistItem with _$ReleaseChecklistItem {
  const ReleaseChecklistItem._();

  const factory ReleaseChecklistItem({
    required String id,
    required String title,
    required String status,
    String? owner,
    String? notes,
  }) = _ReleaseChecklistItem;

  factory ReleaseChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ReleaseChecklistItemFromJson(json);
}
