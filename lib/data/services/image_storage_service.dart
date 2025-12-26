import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  static const int maxImagesPerRecipe = 5;
  static const int maxImageBytes = 5 * 1024 * 1024; // 5MB

  Future<Directory> _getImageDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'recipe_images'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> saveImage(File source, {required String recipeId}) async {
    final dir = await _getImageDir();
    final fileName = p.basename(source.path);
    final target = File(p.join(dir.path, '${recipeId}_$fileName'));
    return source.copy(target.path);
  }

  bool isWithinLimit(int existingCount) =>
      existingCount < maxImagesPerRecipe;

  bool isSizeAllowed(int sizeBytes) => sizeBytes <= maxImageBytes;
}
