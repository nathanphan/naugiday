import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/presentation/widgets/recipe_image_grid.dart';

void main() {
  testWidgets('shows disabled message when images are disabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeImageGrid(
            images: const [],
            onAddImage: _noop,
            onRemove: _noopRemove,
            isEnabled: false,
            disabledMessage: 'Images are disabled.',
          ),
        ),
      ),
    );

    expect(find.text('Images are disabled.'), findsOneWidget);
    final button = tester.widget<TextButton>(
      find.byKey(const Key('add-image-button')),
    );
    expect(button.onPressed, isNull);
  });
}

Future<void> _noop() async {}

void _noopRemove(int _) {}
