import 'dart:convert';
import 'dart:io';

import 'package:naugiday/domain/entities/cooking_step.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/entities/recipe_entities.dart';
import 'package:naugiday/domain/entities/recipe_image.dart';
import 'package:naugiday/data/services/image_storage_service.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'add_recipe_controller.g.dart';

class AddRecipeState {
  final String title;
  final String description;
  final MealType mealType;
  final List<Ingredient> ingredients;
  final List<CookingStep> steps;
  final List<RecipeImage> images;
  final bool isSaving;
  final String? error;

  const AddRecipeState({
    required this.title,
    required this.description,
    required this.mealType,
    required this.ingredients,
    required this.steps,
    required this.images,
    this.isSaving = false,
    this.error,
  });

  AddRecipeState copyWith({
    String? title,
    String? description,
    MealType? mealType,
    List<Ingredient>? ingredients,
    List<CookingStep>? steps,
    List<RecipeImage>? images,
    bool? isSaving,
    String? error,
  }) {
    return AddRecipeState(
      title: title ?? this.title,
      description: description ?? this.description,
      mealType: mealType ?? this.mealType,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      images: images ?? this.images,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

@riverpod
class AddRecipeController extends _$AddRecipeController {
  late final RecipeRepository _repository;
  static const _uuid = Uuid();
  String? _editingRecipeId;
  DateTime? _editingCreatedAt;

  @override
  AddRecipeState build() {
    _repository = ref.watch(recipeRepositoryProvider);
    return AddRecipeState(
      title: '',
      description: '',
      mealType: MealType.dinner,
      ingredients: const [],
      steps: const [],
      images: const [],
    );
  }

  void setTitle(String value) {
    state = state.copyWith(title: value, error: null);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value, error: null);
  }

  void setMealType(MealType mealType) {
    state = state.copyWith(mealType: mealType, error: null);
  }

  void loadFromRecipe(Recipe recipe) {
    _editingRecipeId = recipe.id;
    _editingCreatedAt = recipe.createdAt;
    final steps = recipe.cookingSteps.isNotEmpty
        ? List<CookingStep>.from(recipe.cookingSteps)
        : [
            for (var i = 0; i < recipe.steps.length; i++)
              CookingStep(
                id: _uuid.v4(),
                position: i + 1,
                instruction: recipe.steps[i],
              ),
          ];
    state = state.copyWith(
      title: recipe.name,
      description: recipe.description,
      mealType: recipe.mealType,
      ingredients: List.from(recipe.ingredients),
      steps: steps,
      images: List.from(recipe.images),
      isSaving: false,
      error: null,
    );
  }

  void addIngredient(Ingredient ingredient) {
    final updated = [...state.ingredients, ingredient];
    state = state.copyWith(ingredients: updated, error: null);
  }

  void updateIngredient(int index, Ingredient ingredient) {
    final updated = [...state.ingredients];
    updated[index] = ingredient;
    state = state.copyWith(ingredients: updated, error: null);
  }

  void removeIngredient(int index) {
    final updated = [...state.ingredients]..removeAt(index);
    state = state.copyWith(ingredients: updated, error: null);
  }

  void addStep(CookingStep step) {
    final updated = [...state.steps, step]
      ..sort((a, b) => a.position.compareTo(b.position));
    state = state.copyWith(steps: _normalizePositions(updated), error: null);
  }

  void updateStep(int index, CookingStep step) {
    final updated = [...state.steps];
    updated[index] = step;
    state = state.copyWith(steps: _normalizePositions(updated), error: null);
  }

  void removeStep(int index) {
    final updated = [...state.steps]..removeAt(index);
    state = state.copyWith(steps: _normalizePositions(updated), error: null);
  }

  void moveStepUp(int index) {
    if (index <= 0 || index >= state.steps.length) return;
    final updated = [...state.steps];
    final tmp = updated[index - 1];
    updated[index - 1] = updated[index];
    updated[index] = tmp;
    state = state.copyWith(steps: _normalizePositions(updated), error: null);
  }

  void moveStepDown(int index) {
    if (index < 0 || index >= state.steps.length - 1) return;
    final updated = [...state.steps];
    final tmp = updated[index + 1];
    updated[index + 1] = updated[index];
    updated[index] = tmp;
    state = state.copyWith(steps: _normalizePositions(updated), error: null);
  }

  List<CookingStep> _normalizePositions(List<CookingStep> steps) {
    return [
      for (var i = 0; i < steps.length; i++)
        steps[i].copyWith(position: i + 1),
    ];
  }

  Future<void> addImageFromFile(File file) async {
    final images = state.images;
    if (images.length >= ImageStorageService.maxImagesPerRecipe) {
      state = state.copyWith(error: 'Image limit reached');
      return;
    }
    final size = await file.length();
    if (size > ImageStorageService.maxImageBytes) {
      state = state.copyWith(error: 'Image too large (max 5MB)');
      return;
    }
    final image = RecipeImage(
      id: const Uuid().v4(),
      localPath: file.path,
      fileName: file.uri.pathSegments.last,
      fileSizeBytes: size,
      addedAt: DateTime.now(),
    );
    final updated = [...images, image];
    state = state.copyWith(images: updated, error: null);
  }

  Future<void> addSampleImageForTest() async {
    final dir = await Directory.systemTemp.createTemp('recipe_img');
    final file = File('${dir.path}/${_uuid.v4()}.png');
    const samplePngBase64 =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/xcAAgMBg5pYpVQAAAAASUVORK5CYII=';
    final bytes = base64Decode(samplePngBase64);
    await file.writeAsBytes(bytes, flush: true);
    await addImageFromFile(file);
  }

  void removeImage(int index) {
    final updated = [...state.images]..removeAt(index);
    state = state.copyWith(images: updated, error: null);
  }

  void handlePermissionDenied() {
    state = state.copyWith(error: 'Permission denied for photos');
  }

  Recipe _toRecipe({String? id, DateTime? createdAt}) {
    final now = DateTime.now();
    final steps = state.steps;
    final sortedSteps = steps.isEmpty ? const <CookingStep>[] : [...steps]
      ..sort((a, b) => a.position.compareTo(b.position));
    final stepTexts = sortedSteps.isEmpty
        ? const <String>[]
        : sortedSteps.map((e) => e.instruction).toList();
    return Recipe(
      id: id ?? _uuid.v4(),
      name: state.title,
      description: state.description,
      cookingTimeMinutes: 30,
      difficulty: RecipeDifficulty.medium,
      ingredients: state.ingredients,
      steps: stepTexts,
      cookingSteps: sortedSteps,
      images: state.images,
      nutrition: const NutritionInfo(
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
      ),
      mealType: state.mealType,
      isUserCreated: true,
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  RecipeValidationResult validate() {
    return validateRecipeDraft(_toRecipe());
  }

  Future<bool> save() async {
    final validation = validate();
    if (!validation.isValid) {
      state = state.copyWith(error: validation.errors.join(', '));
      return false;
    }
    state = state.copyWith(isSaving: true, error: null);
    try {
      final recipe = _toRecipe(
        id: _editingRecipeId,
        createdAt: _editingCreatedAt,
      );
      if (_editingRecipeId == null) {
        await _repository.saveRecipe(recipe);
      } else {
        await _repository.updateRecipe(recipe);
      }
      state = state.copyWith(isSaving: false);
      return true;
    } catch (err) {
      state = state.copyWith(
        isSaving: false,
        error: err.toString(),
      );
      return false;
    }
  }
}
