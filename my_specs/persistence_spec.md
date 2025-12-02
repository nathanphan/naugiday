# Data Persistence Specification

## Overview
The app currently needs a robust way to save "My Recipes". This specification outlines the use of **Hive** (a lightweight, NoSQL database) for storing recipe data locally on the device.

## Technology Choice
- **Solution**: Hive (or Isar).
- **Reasoning**: Fast, lightweight, easy to use with Flutter, and supports custom objects via code generation.

## Schema Design

### Recipe Model Adapter
We need to generate a Hive TypeAdapter for the `Recipe` entity and its related classes (`Ingredient`, `Nutrition`, `Difficulty`).

```dart
@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  // ... other fields
}
```

## Implementation Steps

### 1. Dependencies
- Add `hive`, `hive_flutter`.
- Add `hive_generator`, `build_runner` to dev_dependencies.

### 2. Type Adapters
- Annotate existing domain entities with Hive annotations.
- Run `flutter pub run build_runner build` to generate adapters.

### 3. Repository Implementation
- Create `HiveRecipeRepository` implementing `LocalRecipeRepository`.
- **Methods**:
    - `saveRecipe(Recipe recipe)`: Put object in Hive box.
    - `getRecipes()`: Return values from Hive box.
    - `deleteRecipe(String id)`: Delete from Hive box.
    - `getRecipe(String id)`: Retrieve specific recipe.

### 4. Initialization
- Initialize Hive in `main.dart`.
- Open the 'recipes' box before app startup.

## Migration Strategy
- Since we are starting fresh, no complex migration is needed.
- Future versioning: Use Hive's typeId and field indices carefully to allow adding fields without breaking existing data.
