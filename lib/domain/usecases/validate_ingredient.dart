import 'package:naugiday/core/constants/ingredient_constants.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';

class IngredientValidationResult {
  final bool isValid;
  final List<String> errors;
  final bool hasDuplicate;

  const IngredientValidationResult({
    required this.isValid,
    this.errors = const [],
    this.hasDuplicate = false,
  });
}

class ValidateIngredient {
  IngredientValidationResult call(
    PantryIngredient ingredient, {
    Iterable<PantryIngredient> existing = const [],
  }) {
    final errors = <String>[];
    if (ingredient.name.trim().isEmpty) {
      errors.add('Name is required');
    }
    if (ingredient.categoryId.trim().isEmpty) {
      errors.add('Category is required');
    }
    if (ingredient.unit.trim().isEmpty) {
      errors.add('Unit is required');
    }
    if (ingredient.quantity <= 0) {
      errors.add('Quantity must be greater than zero');
    }
    if (ingredient.photos.length > maxIngredientPhotos) {
      errors.add('You can add up to $maxIngredientPhotos photos');
    }
    if (ingredient.photos.any((photo) => photo.path.trim().isEmpty)) {
      errors.add('Remove or reselect missing photos');
    }
    final expiryDate = ingredient.expiryDate;
    if (expiryDate != null && expiryDate.isBefore(DateTime.now())) {
      errors.add('Expiry date cannot be in the past');
    }
    final hasDuplicate = existing.any(
      (item) =>
          item.id != ingredient.id &&
          item.name.trim().toLowerCase() ==
              ingredient.name.trim().toLowerCase(),
    );
    return IngredientValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      hasDuplicate: hasDuplicate,
    );
  }
}
