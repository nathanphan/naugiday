import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/screens/ingredients/ingredient_detail_screen.dart';

class _TestIngredientController extends IngredientController {
  _TestIngredientController(this._items);

  final List<PantryIngredient> _items;

  @override
  Future<List<PantryIngredient>> build() async => _items;
}

class _TestRecipeController extends RecipeController {
  _TestRecipeController(this._recipes);

  final List<Recipe> _recipes;

  @override
  Future<List<Recipe>> build() async => _recipes;
}

class _TestFeatureFlagController extends FeatureFlagController {
  @override
  Future<FeatureFlagState> build() async {
    return FeatureFlagState(
      aiEnabled: false,
      imagesEnabled: true,
      ingredientsEnabled: true,
      ingredientPhotosEnabled: true,
      updatedAt: DateTime(2024, 1, 1),
      source: 'test',
    );
  }
}

PantryIngredient _ingredient() => PantryIngredient(
      id: 'i1',
      name: 'Tomatoes',
      categoryId: 'fridge',
      categoryName: 'Fridge',
      quantity: 2,
      unit: 'pcs',
      expiryDate: DateTime.now().add(const Duration(days: 2)),
      freshnessOverride: true,
      inventoryState: IngredientInventoryState.inStock,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    );

void main() {
  testWidgets('shows ingredient details and delete confirmation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ingredientControllerProvider.overrideWith(
            () => _TestIngredientController([_ingredient()]),
          ),
          recipeControllerProvider.overrideWith(
            () => _TestRecipeController(const []),
          ),
          featureFlagControllerProvider.overrideWith(
            () => _TestFeatureFlagController(),
          ),
        ],
        child: const MaterialApp(
          home: IngredientDetailScreen(ingredientId: 'i1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tomatoes'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Your Ingredient Details'),
      200,
    );
    expect(find.text('Your Ingredient Details'), findsOneWidget);
    expect(find.text('QUANTITY'), findsOneWidget);
    expect(find.text('LOCATION'), findsOneWidget);
    expect(find.text('PURCHASED'), findsOneWidget);
    expect(find.text('EXPIRES'), findsOneWidget);
    expect(find.textContaining('Expiring'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete ingredient'), findsOneWidget);
    expect(find.text('This action cannot be undone. Do you want to delete it?'),
        findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Delete ingredient'), findsNothing);
  });
}
