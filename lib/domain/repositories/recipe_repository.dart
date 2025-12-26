import 'package:naugiday/domain/entities/recipe.dart';

/// Contract for offline-first recipe storage including ingredients, steps,
/// and locally referenced images.
abstract class RecipeRepository {
  Future<List<Recipe>> getMyRecipes();
  Future<void> saveRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<List<Recipe>> recoverCorruptedEntries();
}
