import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/data/dtos/recipe_dto.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/nutrition_info.dart';
import 'package:naugiday/domain/entities/recipe.dart';

void main() {
  group('Recipe', () {
    test('should support value equality', () {
      const nutrition = NutritionInfo(calories: 100, protein: 10, carbs: 10, fat: 10);
      const ingredient = Ingredient(id: '1', name: 'Test', quantity: '1');
      
      final recipe1 = Recipe(
        id: '1',
        name: 'Test',
        description: 'Desc',
        cookingTimeMinutes: 10,
        difficulty: RecipeDifficulty.easy,
        ingredients: [ingredient],
        steps: ['Step 1'],
        nutrition: nutrition,
        mealType: MealType.breakfast,
      );

      final recipe2 = recipe1.copyWith();

      expect(recipe1, equals(recipe2));
    });

    test('should map to/from DTO correctly', () {
      const nutrition = NutritionInfo(calories: 100, protein: 10, carbs: 10, fat: 10);
      const ingredient = Ingredient(id: '1', name: 'Test', quantity: '1');
      
      final recipe = Recipe(
        id: '1',
        name: 'Test',
        description: 'Desc',
        cookingTimeMinutes: 10,
        difficulty: RecipeDifficulty.easy,
        ingredients: [ingredient],
        steps: ['Step 1'],
        nutrition: nutrition,
        mealType: MealType.breakfast,
      );

      final dto = RecipeDto.fromDomain(recipe);
      final mappedRecipe = dto.toDomain();

      expect(mappedRecipe, equals(recipe));
    });
  });
}
