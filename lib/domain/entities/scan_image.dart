import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_image.freezed.dart';
part 'scan_image.g.dart';

enum ScanImageSource { camera, gallery }

enum ScanImageStatus { queued, processing, processed, failed }

@freezed
abstract class ScanImage with _$ScanImage {
  const ScanImage._();

  const factory ScanImage({
    required String id,
    required ScanImageSource source,
    required String path,
    String? thumbnailPath,
    required int sizeBytes,
    required DateTime createdAt,
    required ScanImageStatus status,
    String? failureReason,
  }) = _ScanImage;

  factory ScanImage.fromJson(Map<String, dynamic> json) =>
      _$ScanImageFromJson(json);
}
