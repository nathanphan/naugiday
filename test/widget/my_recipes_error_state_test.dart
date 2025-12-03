import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/presentation/providers/recipe_controller.dart';
import 'package:naugiday/presentation/screens/my_recipes_screen.dart';

class _ErrorRecipeController extends RecipeController {
  @override
  Future<List<Recipe>> build() async {
    throw Exception('storage error');
  }
}

void main() {
  testWidgets('My Recipes shows illustrated repair card on storage error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeControllerProvider.overrideWith(() => _ErrorRecipeController()),
        ],
        child: const MaterialApp(home: MyRecipesScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('We hit a storage issue.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Repair storage'), findsOneWidget);
  });
}
