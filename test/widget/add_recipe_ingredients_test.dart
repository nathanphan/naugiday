import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/presentation/providers/add_recipe_controller.dart';
import 'package:naugiday/domain/entities/meal_type.dart';
import 'package:naugiday/domain/entities/recipe.dart';
import 'package:naugiday/domain/repositories/recipe_repository.dart';
import 'package:naugiday/presentation/providers/recipe_repository_provider.dart';
import 'package:naugiday/presentation/screens/create_recipe_screen.dart';

class _FakeRecipeRepository implements RecipeRepository {
  final List<Recipe> store = [];

  @override
  Future<void> deleteRecipe(String id) async {
    store.removeWhere((r) => r.id == id);
  }

  @override
  Future<List<Recipe>> getMyRecipes() async => List.unmodifiable(store);

  @override
  Future<List<Recipe>> recoverCorruptedEntries() async => getMyRecipes();

  @override
  Future<void> saveRecipe(Recipe recipe) async {
    store.removeWhere((r) => r.id == recipe.id);
    store.add(recipe);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async => saveRecipe(recipe);
}

void main() {
  testWidgets('blocks save when no ingredients', (tester) async {
    final repo = _FakeRecipeRepository();
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeRepositoryProvider.overrideWith((ref) => repo),
        ],
        child: Builder(builder: (context) {
          container = ProviderScope.containerOf(context);
          return const MaterialApp(home: CreateRecipeScreen());
        }),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'My Recipe');
    await tester.pumpAndSettle();
    // Save via controller to avoid flaky button find.
    final controller = container.read(addRecipeControllerProvider.notifier);
    controller.setTitle('My Recipe');
    controller.setMealType(MealType.dinner);
    final ok = await controller.save();

    expect(ok, isFalse);
    expect(repo.store, isEmpty);
  });

  testWidgets('saves recipe with ingredient', (tester) async {
    final repo = _FakeRecipeRepository();
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recipeRepositoryProvider.overrideWith((ref) => repo),
        ],
        child: Builder(builder: (context) {
          container = ProviderScope.containerOf(context);
          return const MaterialApp(home: CreateRecipeScreen());
        }),
      ),
    );

    await tester.enterText(find.byType(TextFormField).first, 'Pho Bo');

    // Add ingredient via dialog.
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Name'), 'Beef');
    await tester.enterText(find.bySemanticsLabel('Quantity'), '200g');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final controller = container.read(addRecipeControllerProvider.notifier);
    controller.setTitle('Pho Bo');
    controller.setMealType(MealType.dinner);
    final ok = await controller.save();
    expect(ok, isTrue);

    expect(repo.store.length, 1);
    expect(repo.store.first.name, 'Pho Bo');
    expect(repo.store.first.ingredients.first.name, 'Beef');
    expect(repo.store.first.ingredients.first.quantity, '200g');
  });
}
