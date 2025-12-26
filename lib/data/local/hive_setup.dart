import 'package:hive_flutter/hive_flutter.dart';
import 'package:naugiday/data/adapters/recipe_adapter.dart';

const String recipesBoxName = 'recipes';

Future<void> initHiveForRecipes({
  String? storagePath,
  bool useFlutter = true,
}) async {
  if (useFlutter) {
    await Hive.initFlutter(storagePath);
  } else {
    if (storagePath != null) {
      Hive.init(storagePath);
    }
  }

  if (!Hive.isAdapterRegistered(nutritionInfoTypeId)) {
    Hive.registerAdapter(NutritionInfoDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(ingredientTypeId)) {
    Hive.registerAdapter(IngredientDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(cookingStepTypeId)) {
    Hive.registerAdapter(CookingStepDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(recipeImageTypeId)) {
    Hive.registerAdapter(RecipeImageDtoAdapter());
  }
  if (!Hive.isAdapterRegistered(recipeTypeId)) {
    Hive.registerAdapter(RecipeDtoAdapter());
  }

  if (!Hive.isBoxOpen(recipesBoxName)) {
    await Hive.openBox(recipesBoxName);
  }
}
