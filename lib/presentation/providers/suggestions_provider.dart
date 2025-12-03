import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/data/datasources/fake_ai_recipe_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:naugiday/core/debug/debug_toggles.dart';

part 'suggestions_provider.g.dart';

@riverpod
Future<({List<String> detectedIngredients, List<Recipe> recipes})> suggestions(
  Ref ref, {
  required List<String> imagePaths,
  required MealType mealType,
  List<String>? labels,
}) async {
  if (DebugToggles.suggestionsMode == SuggestionsDebugMode.loading) {
    await Future.delayed(const Duration(days: 1));
  }
  if (DebugToggles.suggestionsMode == SuggestionsDebugMode.error) {
    throw Exception('Debug: suggestions error');
  }
  if (DebugToggles.suggestionsMode == SuggestionsDebugMode.empty) {
    return (detectedIngredients: labels ?? <String>[], recipes: <Recipe>[]);
  }
  final service = ref.watch(aiRecipeServiceProvider);
  final result = await service.suggestRecipesFromImages(
    imagePaths: imagePaths,
    mealType: mealType,
  );
  if (labels != null && labels.isNotEmpty) {
    return (detectedIngredients: labels, recipes: result.recipes);
  }
  return result;
}
