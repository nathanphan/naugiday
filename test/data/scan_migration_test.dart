import 'package:flutter_test/flutter_test.dart';
import 'package:hive/src/adapters/date_time_adapter.dart';
import 'package:hive/src/binary/binary_reader_impl.dart';
import 'package:hive/src/binary/binary_writer_impl.dart';
import 'package:hive/src/registry/type_registry_impl.dart';
import 'package:naugiday/data/adapters/scan_image_adapter.dart';
import 'package:naugiday/data/adapters/scan_queue_item_adapter.dart';

void main() {
  test('scan image adapter handles legacy payloads with defaults', () {
    final registry = TypeRegistryImpl()..registerAdapter(DateTimeAdapter());
    final writer = BinaryWriterImpl(registry);
    writer.writeString('legacy-image');
    writer.writeString('camera');
    writer.writeString('/tmp/legacy.jpg');
    final reader = BinaryReaderImpl(writer.toBytes(), registry);

    final dto = ScanImageDtoAdapter().read(reader);
    expect(dto.id, 'legacy-image');
    expect(dto.sizeBytes, 0);
    expect(dto.status, 'queued');
  });

  test('scan queue adapter handles legacy payloads with defaults', () {
    final registry = TypeRegistryImpl()..registerAdapter(DateTimeAdapter());
    final writer = BinaryWriterImpl(registry);
    writer.writeString('legacy-queue');
    writer.writeString('legacy-image');
    writer.write(DateTime(2024, 1, 1));
    final reader = BinaryReaderImpl(writer.toBytes(), registry);

    final dto = ScanQueueItemDtoAdapter().read(reader);
    expect(dto.id, 'legacy-queue');
    expect(dto.retryCount, 0);
    expect(dto.status, 'queued');
  });
}
