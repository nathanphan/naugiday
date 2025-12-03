import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/presentation/screens/scan_screen.dart';

void main() {
  testWidgets('Camera unavailable shows settings and retry actions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ScanScreen(forceCameraUnavailable: true)));
    await tester.pumpAndSettle();

    expect(find.text('Camera not available'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
