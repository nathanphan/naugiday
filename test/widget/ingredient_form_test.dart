import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/presentation/providers/ingredient_filters_provider.dart';
import 'package:naugiday/presentation/providers/ingredient_form_controller.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_form.dart';

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
  testWidgets('shows validation errors and duplicate warning', (tester) async {
    final container = ProviderContainer(
      overrides: [
        ingredientCategoriesProvider.overrideWith(
          (ref) async => _categories(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: IngredientForm()),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final controller =
        container.read(ingredientFormControllerProvider.notifier);
    controller.state = controller.state.copyWith(
      categoryId: 'fridge',
      categoryName: 'Fridge',
      errors: const ['Name is required'],
      hasDuplicate: true,
    );

    await tester.pump();

    expect(find.text('Name is required'), findsOneWidget);
    expect(
      find.textContaining('This name already exists'),
      findsOneWidget,
    );
  });
}
