import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/presentation/providers/ingredient_controller.dart';
import 'package:naugiday/presentation/screens/ingredients/ingredient_bulk_manage_screen.dart';

class _TestIngredientController extends IngredientController {
  _TestIngredientController(this._items);

  final List<PantryIngredient> _items;

  @override
  Future<List<PantryIngredient>> build() async => _items;
}

PantryIngredient _ingredient(String id) => PantryIngredient(
      id: id,
      name: 'Item $id',
      categoryId: 'fridge',
      categoryName: 'Fridge',
      quantity: 1,
      unit: 'pcs',
      expiryDate: null,
      freshnessOverride: true,
      inventoryState: IngredientInventoryState.inStock,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 2),
    );

void main() {
  testWidgets('shows prompt when applying bulk update with no selection',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ingredientControllerProvider.overrideWith(
            () => _TestIngredientController([_ingredient('1')]),
          ),
        ],
        child: const MaterialApp(home: IngredientBulkManageScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Apply update'));
    await tester.pump();

    expect(find.text('Select at least one ingredient'), findsOneWidget);
  });
}
