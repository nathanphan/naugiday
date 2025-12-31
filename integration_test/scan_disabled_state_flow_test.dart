import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:naugiday/presentation/providers/feature_flag_provider.dart';
import 'package:naugiday/presentation/screens/scan_screen.dart';

class _ScanDisabledFlagController extends FeatureFlagController {
  @override
  Future<FeatureFlagState> build() async {
    return FeatureFlagState(
      aiEnabled: true,
      imagesEnabled: true,
      ingredientsEnabled: true,
      ingredientPhotosEnabled: true,
      scanEnabled: false,
      updatedAt: DateTime(2024, 1, 1),
      source: 'test',
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('disabled state shows alternatives', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          featureFlagControllerProvider.overrideWith(
            () => _ScanDisabledFlagController(),
          ),
        ],
        child: const MaterialApp(
          home: ScanScreen(forceCameraUnavailable: true),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Scanner is Taking a Break'), findsOneWidget);
  });
}
