import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/adapters/recipe_adapter.dart';

const String recipesBoxName = 'recipes';

Future<void> initHiveForRecipes({
  String? storagePath,
  bool useFlutter = true,
  bool recoverOnTypeIdMismatch = kDebugMode,
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
    try {
      await Hive.openBox(recipesBoxName);
    } on HiveError catch (err) {
      final message = err.message;
      final shouldRecover =
          recoverOnTypeIdMismatch && message.contains('unknown typeId');
      if (!shouldRecover) rethrow;
      // Destructive recovery for schema mismatches in debug builds.
      await Hive.deleteBoxFromDisk(recipesBoxName);
      await Hive.openBox(recipesBoxName);
    }
  }

  if (!Hive.isBoxOpen(featureFlagsBoxName)) {
    await Hive.openBox(featureFlagsBoxName);
  }
  if (!Hive.isBoxOpen(telemetryQueueBoxName)) {
    await Hive.openBox(telemetryQueueBoxName);
  }
  if (!Hive.isBoxOpen(releaseChecklistBoxName)) {
    await Hive.openBox(releaseChecklistBoxName);
  }
}
