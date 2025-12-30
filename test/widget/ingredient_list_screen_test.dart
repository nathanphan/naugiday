import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/providers/ingredient_filters_provider.dart';
import 'package:naugiday/presentation/screens/ingredients/ingredient_list_screen.dart';

class _TestIngredientController extends IngredientController {
  _TestIngredientController(this._items);

  final List<PantryIngredient> _items;

  @override
  Future<List<PantryIngredient>> build() async => _items;
}

class _ErrorIngredientController extends IngredientController {
  @override
  Future<List<PantryIngredient>> build() async {
    throw Exception('load failed');
  }
}

class _TestFeatureFlagController extends FeatureFlagController {
  _TestFeatureFlagController(this.enabled);

  final bool enabled;

  @override
  Future<FeatureFlagState> build() async {
    return FeatureFlagState(
      aiEnabled: false,
      imagesEnabled: false,
      ingredientsEnabled: enabled,
      ingredientPhotosEnabled: enabled,
      updatedAt: DateTime(2024, 1, 1),
      source: 'test',
    );
  }
}

PantryIngredient _ingredient({
  required String id,
  required String name,
  required String categoryId,
  required String categoryName,
}) {
  return PantryIngredient(
    id: id,
    name: name,
    categoryId: categoryId,
    categoryName: categoryName,
    quantity: 1,
    unit: 'pcs',
    expiryDate: null,
    freshnessOverride: true,
    inventoryState: IngredientInventoryState.inStock,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 2),
  );
}

List<IngredientCategory> _categories() => [
      IngredientCategory(
        id: 'fridge',
        name: 'Fridge',
        isCustom: false,
        createdAt: DateTime(2024, 1, 1),
      ),
      IngredientCategory(
        id: 'pantry',
        name: 'Pantry',
        isCustom: false,
        createdAt: DateTime(2024, 1, 1),
      ),
      IngredientCategory(
        id: 'freezer',
        name: 'Freezer',
        isCustom: false,
        createdAt: DateTime(2024, 1, 1),
      ),
    ];

void main() {
  testWidgets('shows empty state when no ingredients', (tester) async {
    final container = ProviderContainer(
      overrides: [
        ingredientControllerProvider.overrideWith(
          () => _TestIngredientController(const []),
        ),
        ingredientCategoriesProvider.overrideWith(
          (ref) async => _categories(),
        ),
        featureFlagControllerProvider.overrideWith(
          () => _TestFeatureFlagController(true),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: IngredientListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No ingredients yet'), findsOneWidget);
    expect(find.text('Add ingredient'), findsOneWidget);
  });

  testWidgets('shows no matches when search filters yield none', (tester) async {
    final ingredients = [
      _ingredient(
        id: '1',
        name: 'Milk',
        categoryId: 'fridge',
        categoryName: 'Fridge',
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        ingredientControllerProvider.overrideWith(
          () => _TestIngredientController(ingredients),
        ),
        ingredientCategoriesProvider.overrideWith(
          (ref) async => _categories(),
        ),
        featureFlagControllerProvider.overrideWith(
          () => _TestFeatureFlagController(true),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: IngredientListScreen()),
      ),
    );

    container.read(ingredientFiltersProvider.notifier).setQuery('zzz');

    await tester.pumpAndSettle();

    expect(find.text('No matches'), findsOneWidget);
    expect(find.text('Milk'), findsNothing);
  });

  testWidgets('shows error state when loading fails', (tester) async {
    final container = ProviderContainer(
      overrides: [
        ingredientControllerProvider.overrideWith(
          () => _ErrorIngredientController(),
        ),
        ingredientCategoriesProvider.overrideWith(
          (ref) async => _categories(),
        ),
        featureFlagControllerProvider.overrideWith(
          () => _TestFeatureFlagController(true),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: IngredientListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('We could not load ingredients.'), findsOneWidget);
  });
}
