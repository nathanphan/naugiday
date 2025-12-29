import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/domain/entities/ingredient.dart';
import 'package:naugiday/presentation/widgets/ingredient_tile.dart';
import 'package:naugiday/presentation/widgets/quick_actions_row.dart';

void main() {
  testWidgets('quick actions meet minimum tap size', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: QuickActionsRow(),
          ),
        ),
      ),
    );

    final action = find.byType(InkWell).first;
    final size = tester.getSize(action);
    expect(size.width >= 48, isTrue);
    expect(size.height >= 48, isTrue);
  });

  testWidgets('ingredient tile meets minimum tap size', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientTile(
            ingredient: Ingredient(id: '1', name: 'Salt', quantity: '1 tsp'),
            isAvailable: true,
          ),
        ),
      ),
    );

    final tile = find.byType(ListTile).first;
    final size = tester.getSize(tile);
    expect(size.height >= 48, isTrue);
  });
}
