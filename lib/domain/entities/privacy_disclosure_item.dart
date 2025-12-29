import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_disclosure_item.freezed.dart';
part 'privacy_disclosure_item.g.dart';

@freezed
abstract class PrivacyDisclosureItem with _$PrivacyDisclosureItem {
  const PrivacyDisclosureItem._();

  const factory PrivacyDisclosureItem({
    required String id,
    required String type,
    required String title,
    required String description,
    required String status,
    DateTime? lastVerifiedAt,
  }) = _PrivacyDisclosureItem;

  factory PrivacyDisclosureItem.fromJson(Map<String, dynamic> json) =>
      _$PrivacyDisclosureItemFromJson(json);
}
