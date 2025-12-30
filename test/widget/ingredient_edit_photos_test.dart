import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
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
    ];

IngredientPhoto _photo(String id) {
  return IngredientPhoto(
    id: id,
    path: '/tmp/$id.jpg',
    source: IngredientPhotoSource.gallery,
    displayOrder: 0,
    createdAt: DateTime(2024, 1, 1),
  );
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

void main() {
  testWidgets('removes a photo when delete is tapped', (tester) async {
    final container = ProviderContainer(
      overrides: [
        ingredientCategoriesProvider.overrideWith((ref) async => _categories()),
        featureFlagControllerProvider.overrideWith(
          () => _TestFeatureFlagController(),
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
      photos: [_photo('p1')],
    );

    await tester.pump();

    expect(
      find.byKey(const ValueKey('ingredient-photo-thumb-ink-p1')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('ingredient-photo-thumb-ink-p1')),
      findsNothing,
    );
  });
}
