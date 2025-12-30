import 'package:naugiday/data/repositories/local_ingredient_repository.dart';
import 'package:naugiday/data/services/ingredient_photo_picker.dart';
import 'package:naugiday/data/services/ingredient_photo_storage.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_repository_provider.g.dart';

@riverpod
IngredientRepository ingredientRepository(Ref ref) {
  return LocalIngredientRepository(
    photoStorage: ref.watch(ingredientPhotoStorageProvider),
  );
}

@riverpod
IngredientPhotoStorage ingredientPhotoStorage(Ref ref) {
  return IngredientPhotoStorage();
}

@riverpod
IngredientPhotoPicker ingredientPhotoPicker(Ref ref) {
  return IngredientPhotoPicker();
}
