import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/scan_image_dto.dart';

const int scanImageTypeId = 8;

class ScanImageDtoAdapter extends TypeAdapter<ScanImageDto> {
  @override
  final int typeId = scanImageTypeId;

  @override
  ScanImageDto read(BinaryReader reader) {
    final id = reader.readString();
    final source = reader.readString();
    final path = reader.readString();
    final thumbnailPath =
        reader.availableBytes > 0 ? reader.read() as String? : null;
    final sizeBytes = reader.availableBytes > 0 ? reader.readInt() : 0;
    final createdAt = reader.availableBytes > 0
        ? reader.read() as DateTime
        : DateTime.now();
    final status = reader.availableBytes > 0
        ? reader.readString()
        : 'queued';
    final failureReason =
        reader.availableBytes > 0 ? reader.read() as String? : null;
    return ScanImageDto(
      id: id,
      source: source,
      path: path,
      thumbnailPath: thumbnailPath,
      sizeBytes: sizeBytes,
      createdAt: createdAt,
      status: status,
      failureReason: failureReason,
    );
  }

  @override
  void write(BinaryWriter writer, ScanImageDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.source)
      ..writeString(obj.path)
      ..write(obj.thumbnailPath)
      ..writeInt(obj.sizeBytes)
      ..write(obj.createdAt)
      ..writeString(obj.status)
      ..write(obj.failureReason);
  }
}
