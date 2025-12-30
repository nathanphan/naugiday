import 'dart:io';

import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/domain/errors/ingredient_storage_exception.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class IngredientPhotoStorage {
  Directory? _baseDirectory;

  Future<Directory> _resolveBaseDirectory() async {
    if (_baseDirectory != null) return _baseDirectory!;
    final documents = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(documents.path, 'ingredient_photos'));
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

  Future<bool> exists(String path) async {
    return File(path).exists();
  }

  Future<IngredientPhoto> persistIfNeeded(IngredientPhoto photo) async {
    if (await isManagedPath(photo.path)) {
      return photo;
    }
    final file = File(photo.path);
    final exists = await file.exists();
    if (!exists) {
      throw IngredientStorageException.validation(
        'One or more photos are missing. Please remove or reselect them.',
      );
    }
    final base = await _resolveBaseDirectory();
    final ext = p.extension(photo.path);
    final normalizedExt = ext.isEmpty ? '.jpg' : ext;
    final destPath = p.join(base.path, '${photo.id}$normalizedExt');
    await file.copy(destPath);
    return photo.copyWith(path: destPath);
  }

  Future<List<IngredientPhoto>> persistAll(
    List<IngredientPhoto> photos,
  ) async {
    final persisted = <IngredientPhoto>[];
    for (var index = 0; index < photos.length; index += 1) {
      final updated = await persistIfNeeded(photos[index]);
      persisted.add(updated.copyWith(displayOrder: index));
    }
    return persisted;
  }

  Future<void> deleteIfManaged(String path) async {
    if (!await isManagedPath(path)) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> deleteRemoved({
    required List<IngredientPhoto> existing,
    required List<IngredientPhoto> updated,
  }) async {
    final remainingIds = updated.map((photo) => photo.id).toSet();
    for (final photo in existing) {
      if (remainingIds.contains(photo.id)) continue;
      await deleteIfManaged(photo.path);
    }
  }
}
