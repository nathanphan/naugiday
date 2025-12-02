import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/data/datasources/fake_ai_recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestions_provider.g.dart';

@riverpod
Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestions(
  Ref ref, {
  required List<String> imagePaths,
  required MealType mealType,
}) async {
  final service = ref.watch(aiRecipeServiceProvider);
  return service.suggestRecipesFromImages(
    imagePaths: imagePaths,
    mealType: mealType,
  );
}
