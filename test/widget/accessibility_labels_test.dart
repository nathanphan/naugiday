import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naugiday/presentation/widgets/home_cta_card.dart';
import 'package:naugiday/presentation/widgets/suggested_recipe_card.dart';

void main() {
  testWidgets('home CTA exposes semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: HomeCTACard(onTap: () {}),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Scan ingredients'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('suggested recipe card exposes semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SuggestedRecipeCard(
            title: 'Pho',
            time: '30m',
            calories: '400 kcal',
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Pho, 30m, 400 kcal'), findsOneWidget);
    handle.dispose();
  });
}
