import 'package:naugiday/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getMyRecipes();
  Future<void> saveRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<List<Recipe>> recoverCorruptedEntries();
}
