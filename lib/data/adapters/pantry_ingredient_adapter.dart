import 'package:hive/hive.dart';
import 'package:naugiday/data/dtos/ingredient_category_dto.dart';
import 'package:naugiday/data/dtos/ingredient_photo_dto.dart';
import 'package:naugiday/data/dtos/pantry_ingredient_dto.dart';

const int pantryIngredientTypeId = 5;
const int ingredientCategoryTypeId = 6;
const int ingredientPhotoTypeId = 7;

class PantryIngredientDtoAdapter extends TypeAdapter<PantryIngredientDto> {
  @override
  final int typeId = pantryIngredientTypeId;

  @override
  PantryIngredientDto read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final categoryId = reader.readString();
    final categoryName = reader.read();
    final quantity = reader.readDouble();
    final unit = reader.readString();
    final expiryDate = reader.read() as DateTime?;
    final freshnessOverride = reader.read() as bool?;
    final inventoryState = reader.readString();
    final createdAt = reader.read() as DateTime;
    final updatedAt = reader.read() as DateTime;
    var photos = <IngredientPhotoDto>[];
    if (reader.availableBytes > 0) {
      final stored = reader.read();
      if (stored is List) {
        photos = stored.whereType<IngredientPhotoDto>().toList(growable: false);
      }
    }
    return PantryIngredientDto(
      id: id,
      name: name,
      categoryId: categoryId,
      categoryName: categoryName as String?,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      freshnessOverride: freshnessOverride,
      inventoryState: inventoryState,
      photos: photos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  void write(BinaryWriter writer, PantryIngredientDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.categoryId)
      ..write(obj.categoryName)
      ..writeDouble(obj.quantity)
      ..writeString(obj.unit)
      ..write(obj.expiryDate)
      ..write(obj.freshnessOverride)
      ..writeString(obj.inventoryState)
      ..write(obj.createdAt)
      ..write(obj.updatedAt)
      ..write(obj.photos);
  }
}

class IngredientCategoryDtoAdapter extends TypeAdapter<IngredientCategoryDto> {
  @override
  final int typeId = ingredientCategoryTypeId;

  @override
  IngredientCategoryDto read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final isCustom = reader.readBool();
    final createdAt = reader.read() as DateTime;
    return IngredientCategoryDto(
      id: id,
      name: name,
      isCustom: isCustom,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientCategoryDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeBool(obj.isCustom)
      ..write(obj.createdAt);
  }
}

class IngredientPhotoDtoAdapter extends TypeAdapter<IngredientPhotoDto> {
  @override
  final int typeId = ingredientPhotoTypeId;

  @override
  IngredientPhotoDto read(BinaryReader reader) {
    final id = reader.readString();
    final path = reader.readString();
    final source = reader.readString();
    final displayOrder = reader.readInt();
    final createdAt = reader.read() as DateTime;
    return IngredientPhotoDto(
      id: id,
      path: path,
      source: source,
      displayOrder: displayOrder,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientPhotoDto obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.path)
      ..writeString(obj.source)
      ..writeInt(obj.displayOrder)
      ..write(obj.createdAt);
  }
}
