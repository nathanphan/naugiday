import 'dart:io';

import 'package:naugiday/core/constants/scan_constants.dart';
import 'package:naugiday/domain/entities/scan_image.dart';
import 'package:naugiday/domain/errors/scan_storage_exception.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ScanImageStorage {
  Directory? _baseDirectory;

  Future<Directory> _resolveBaseDirectory() async {
    if (_baseDirectory != null) return _baseDirectory!;
    final documents = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(documents.path, 'scan_images'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    _baseDirectory = dir;
    return dir;
  }

  Future<bool> isManagedPath(String path) async {
    final base = await _resolveBaseDirectory();
    return p.isWithin(base.path, path) || p.equals(base.path, p.dirname(path));
  }

  Future<int> fileSize(String path) async {
    return File(path).length();
  }

  Future<ScanImage> persistIfNeeded(ScanImage image) async {
    final file = File(image.path);
    if (!await file.exists()) {
      throw ScanStorageException.validation(
        'Selected image is missing. Please pick a different photo.',
      );
    }
    final sizeBytes = await file.length();
    if (sizeBytes > scanMaxImageBytes) {
      throw ScanStorageException.validation(
        'Image is too large. Please choose a smaller image.',
      );
    }
    if (await isManagedPath(image.path)) {
      return image.copyWith(sizeBytes: sizeBytes);
    }
    final base = await _resolveBaseDirectory();
    final ext = p.extension(image.path);
    final normalizedExt = ext.isEmpty ? '.jpg' : ext;
    final destPath = p.join(base.path, '${image.id}$normalizedExt');
    try {
      await file.copy(destPath);
    } catch (err) {
      throw ScanStorageException.write(err);
    }
    return image.copyWith(path: destPath, sizeBytes: sizeBytes);
  }

  Future<void> deleteIfManaged(String path) async {
    if (!await isManagedPath(path)) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
