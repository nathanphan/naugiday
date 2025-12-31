import 'package:image_picker/image_picker.dart';
import 'package:naugiday/core/constants/scan_constants.dart';

class ScanImagePicker {
  ScanImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: scanMaxImageDimension,
      maxHeight: scanMaxImageDimension,
      imageQuality: scanImageQuality,
    );
  }
}
