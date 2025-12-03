import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/ingredient_dto.dart';
import 'package:naugiday/data/dtos/nutrition_info_dto.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';

const int nutritionInfoTypeId = 0;
const int ingredientTypeId = 1;
const int recipeTypeId = 2;

class NutritionInfoDtoAdapter extends TypeAdapter<NutritionInfoDto> {
  @override
  final int typeId = nutritionInfoTypeId;

  @override
  NutritionInfoDto read(BinaryReader reader) {
    return NutritionInfoDto(
      calories: reader.readInt(),
      protein: reader.readInt(),
      carbs: reader.readInt(),
      fat: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, NutritionInfoDto obj) {
    writer
      ..writeInt(obj.calories)
      ..writeInt(obj.protein)
      ..writeInt(obj.carbs)
      ..writeInt(obj.fat);
  }
}

class IngredientDtoAdapter extends TypeAdapter<IngredientDto> {
  @override
  final int typeId = ingredientTypeId;

  @override
  IngredientDto read(BinaryReader reader) {
    return IngredientDto(
      id: reader.readString(),
      name: reader.readString(),
      quantity: reader.readString(),
      category: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, IngredientDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.quantity)
      ..write(obj.category);
  }
}

class RecipeDtoAdapter extends TypeAdapter<RecipeDto> {
  @override
  final int typeId = recipeTypeId;

  @override
  RecipeDto read(BinaryReader reader) {
    final ingredientCount = reader.readInt();
    final ingredients = <IngredientDto>[];
    for (var i = 0; i < ingredientCount; i++) {
      ingredients.add(reader.read() as IngredientDto);
    }
    final stepCount = reader.readInt();
    final steps = <String>[];
    for (var i = 0; i < stepCount; i++) {
      steps.add(reader.readString());
    }

    return RecipeDto(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      cookingTimeMinutes: reader.readInt(),
      difficultyIndex: reader.readInt(),
      ingredients: ingredients,
      steps: steps,
      nutrition: reader.read() as NutritionInfoDto,
      mealTypeIndex: reader.readInt(),
      isUserCreated: reader.readBool(),
      imageUrl: reader.read(),
      createdAt: reader.read() as DateTime?,
      updatedAt: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeDto obj) {
    writer..writeInt(obj.ingredients.length);
    for (final ingredient in obj.ingredients) {
      writer.write(ingredient);
    }
    writer.writeInt(obj.steps.length);
    for (final step in obj.steps) {
      writer.writeString(step);
    }
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.description)
      ..writeInt(obj.cookingTimeMinutes)
      ..writeInt(obj.difficultyIndex)
      ..write(obj.nutrition)
      ..writeInt(obj.mealTypeIndex)
      ..writeBool(obj.isUserCreated)
      ..write(obj.imageUrl)
      ..write(obj.createdAt)
      ..write(obj.updatedAt);
  }
}
