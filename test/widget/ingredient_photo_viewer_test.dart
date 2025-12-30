import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/ingredient_photo.dart';
import 'package:naugiday/presentation/widgets/ingredients/ingredient_photo_viewer.dart';

IngredientPhoto _photo(String id) {
  return IngredientPhoto(
    id: id,
    path: '/tmp/$id.jpg',
    source: IngredientPhotoSource.gallery,
    displayOrder: 0,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  testWidgets('photo viewer shows fallback when image missing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: IngredientPhotoViewer(
          photos: [_photo('p1')],
          initialIndex: 0,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Photo 1 of 1'), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });
}
