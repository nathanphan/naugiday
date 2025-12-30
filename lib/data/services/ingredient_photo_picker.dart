import 'package:image_picker/image_picker.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:uuid/uuid.dart';

class IngredientPhotoPicker {
  IngredientPhotoPicker({
    ImagePicker? picker,
    Uuid? uuid,
  })  : _picker = picker ?? ImagePicker(),
        _uuid = uuid ?? const Uuid();

  final ImagePicker _picker;
  final Uuid _uuid;

  Future<IngredientPhoto?> pickFromCamera() {
    return _pick(ImageSource.camera, IngredientPhotoSource.camera);
  }

  Future<IngredientPhoto?> pickFromGallery() {
    return _pick(ImageSource.gallery, IngredientPhotoSource.gallery);
  }

  Future<IngredientPhoto?> _pick(
    ImageSource source,
    IngredientPhotoSource photoSource,
  ) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (file == null) return null;
    return IngredientPhoto(
      id: _uuid.v4(),
      path: file.path,
      source: photoSource,
      displayOrder: 0,
      createdAt: DateTime.now(),
    );
  }
}
