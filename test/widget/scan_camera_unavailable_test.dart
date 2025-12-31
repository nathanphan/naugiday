import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/presentation/screens/scan_screen.dart';

void main() {
  testWidgets('Camera unavailable shows settings and retry actions', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ScanScreen(forceCameraUnavailable: true)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Oops! Camera Unavailable'), findsOneWidget);
    expect(find.text('Retry Camera'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
  });
}
