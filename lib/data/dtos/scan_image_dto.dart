import 'package:json_annotation/json_annotation.dart';
import 'package:naugiday/domain/entities/scan_image.dart';

part 'scan_image_dto.g.dart';

@JsonSerializable()
class ScanImageDto {
  final String id;
  final String source;
  final String path;
  final String? thumbnailPath;
  final int sizeBytes;
  final DateTime createdAt;
  final String status;
  final String? failureReason;

  ScanImageDto({
    required this.id,
    required this.source,
    required this.path,
    this.thumbnailPath,
    required this.sizeBytes,
    required this.createdAt,
    required this.status,
    this.failureReason,
  });

  factory ScanImageDto.fromDomain(ScanImage image) {
    return ScanImageDto(
      id: image.id,
      source: image.source.name,
      path: image.path,
      thumbnailPath: image.thumbnailPath,
      sizeBytes: image.sizeBytes,
      createdAt: image.createdAt,
      status: image.status.name,
      failureReason: image.failureReason,
    );
  }

  ScanImage toDomain() {
    final parsedSource = ScanImageSource.values.firstWhere(
      (value) => value.name == source,
      orElse: () => ScanImageSource.camera,
    );
    final parsedStatus = ScanImageStatus.values.firstWhere(
      (value) => value.name == status,
      orElse: () => ScanImageStatus.queued,
    );
    return ScanImage(
      id: id,
      source: parsedSource,
      path: path,
      thumbnailPath: thumbnailPath,
      sizeBytes: sizeBytes,
      createdAt: createdAt,
      status: parsedStatus,
      failureReason: failureReason,
    );
  }

  factory ScanImageDto.fromJson(Map<String, dynamic> json) =>
      _$ScanImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScanImageDtoToJson(this);
}
