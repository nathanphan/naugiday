import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/cooking_step_dto.dart';
import 'package:naugiday/data/dtos/ingredient_dto.dart';
import 'package:naugiday/data/dtos/nutrition_info_dto.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/data/dtos/recipe_image_dto.dart';

const int nutritionInfoTypeId = 0;
const int ingredientTypeId = 1;
const int recipeTypeId = 2;
const int cookingStepTypeId = 3;
const int recipeImageTypeId = 4;

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
    final id = reader.readString();
    final name = reader.readString();
    final quantity = reader.readString();
    final category = reader.read();
    final quantityValue = reader.availableBytes > 0 ? reader.read() as double? : null;
    final quantityUnit = reader.availableBytes > 0 ? reader.read() as String? : null;
    final notes = reader.availableBytes > 0 ? reader.read() as String? : null;
    return IngredientDto(
      id: id,
      name: name,
      quantity: quantity,
      category: category,
      quantityValue: quantityValue,
      quantityUnit: quantityUnit,
      notes: notes,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.quantity)
      ..write(obj.category)
      ..write(obj.quantityValue)
      ..write(obj.quantityUnit)
      ..write(obj.notes);
  }
}

class CookingStepDtoAdapter extends TypeAdapter<CookingStepDto> {
  @override
  final int typeId = cookingStepTypeId;

  @override
  CookingStepDto read(BinaryReader reader) {
    return CookingStepDto(
      id: reader.readString(),
      position: reader.readInt(),
      instruction: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, CookingStepDto obj) {
    writer
      ..writeString(obj.id)
      ..writeInt(obj.position)
      ..writeString(obj.instruction);
  }
}

class RecipeImageDtoAdapter extends TypeAdapter<RecipeImageDto> {
  @override
  final int typeId = recipeImageTypeId;

  @override
  RecipeImageDto read(BinaryReader reader) {
    return RecipeImageDto(
      id: reader.readString(),
      localPath: reader.readString(),
      fileName: reader.readString(),
      fileSizeBytes: reader.readInt(),
      addedAt: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeImageDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.localPath)
      ..writeString(obj.fileName)
      ..writeInt(obj.fileSizeBytes)
      ..write(obj.addedAt);
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
    // Cooking steps and images may be absent in legacy entries.
    List<CookingStepDto> cookingSteps = const [];
    if (reader.availableBytes > 0) {
      final count = reader.readInt();
      final list = <CookingStepDto>[];
      for (var i = 0; i < count; i++) {
        list.add(reader.read() as CookingStepDto);
      }
      cookingSteps = list;
    }
    List<RecipeImageDto> images = const [];
    if (reader.availableBytes > 0) {
      final count = reader.readInt();
      final list = <RecipeImageDto>[];
      for (var i = 0; i < count; i++) {
        list.add(reader.read() as RecipeImageDto);
      }
      images = list;
    }

    return RecipeDto(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      cookingTimeMinutes: reader.readInt(),
      difficultyIndex: reader.readInt(),
      ingredients: ingredients,
      steps: steps,
      cookingSteps: cookingSteps,
      images: images,
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
    writer.writeInt(obj.ingredients.length);
    for (final ingredient in obj.ingredients) {
      writer.write(ingredient);
    }
    writer.writeInt(obj.steps.length);
    for (final step in obj.steps) {
      writer.writeString(step);
    }
    writer.writeInt(obj.cookingSteps.length);
    for (final step in obj.cookingSteps) {
      writer.write(step);
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
      ..write(obj.updatedAt)
      ..writeInt(obj.images.length);
    for (final image in obj.images) {
      writer.write(image);
    }
  }
}
