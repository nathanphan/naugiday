import 'package:naugiday/domain/entities/cooking_step.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/recipe_entities.dart';

class RecipeValidation {
  static RecipeValidationResult validateDraft(Recipe recipe) =>
      validateRecipeDraft(recipe);

  static bool ingredientIsValid(Ingredient ingredient) =>
      isIngredientValid(ingredient);

  static bool stepsAreOrdered(List<CookingStep> steps) =>
      areStepsOrdered(steps);
}
