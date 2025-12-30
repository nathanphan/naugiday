import 'package:naugiday/domain/entities/cooking_step.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/recipe.dart';

class RecipeValidationResult {
  final bool isValid;
  final List<String> errors;
  const RecipeValidationResult({required this.isValid, this.errors = const []});
}

RecipeValidationResult validateRecipeDraft(Recipe recipe) {
  final errors = <String>[];
  if (recipe.name.trim().isEmpty) {
    errors.add('Title is required');
  }
  if (recipe.ingredients.isEmpty) {
    errors.add('At least one ingredient is required');
  }
  if (recipe.ingredients.any((ing) => !isIngredientValid(ing))) {
    errors.add('Ingredient names and quantities must be valid');
  }
  if (recipe.cookingSteps.isNotEmpty &&
      !areStepsOrdered(recipe.cookingSteps)) {
    errors.add('Steps must be ordered and non-empty');
  }
  if (recipe.images.length > 5) {
    errors.add('Too many images (max 5)');
  }
  if (recipe.images.any((img) => !img.isValid)) {
    errors.add('All images must have a path and size > 0');
  }
  return RecipeValidationResult(isValid: errors.isEmpty, errors: errors);
}

bool isIngredientValid(Ingredient ingredient) {
  final hasName = ingredient.name.trim().isNotEmpty;
  final hasQuantity = ingredient.quantity.trim().isNotEmpty;
  final hasPositiveValue =
      ingredient.quantityValue == null || ingredient.quantityValue! > 0;
  return hasName && hasQuantity && hasPositiveValue;
}

bool areStepsOrdered(List<CookingStep> steps) {
  if (steps.isEmpty) return true;
  final sorted = List.of(steps)..sort((a, b) => a.position.compareTo(b.position));
  for (var i = 0; i < sorted.length; i++) {
    if (sorted[i].position != i + 1 || sorted[i].instruction.trim().isEmpty) {
      return false;
    }
  }
  return true;
}
