import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/release_checklist_item.dart';
import 'package:naugiday/domain/repositories/release_checklist_repository.dart';
import 'package:naugiday/presentation/providers/release_checklist_provider.dart';
import 'package:naugiday/presentation/screens/release_checklist_screen.dart';

void main() {
  testWidgets('shows checklist items', (tester) async {
    final items = [
      ReleaseChecklistItem(id: '1', title: 'Item A', status: 'pending'),
      ReleaseChecklistItem(id: '2', title: 'Item B', status: 'complete'),
    ];
    final repository = _FakeReleaseChecklistRepository(items);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          releaseChecklistRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: ReleaseChecklistScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Item A'), findsOneWidget);
    expect(find.text('Item B'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(2));
  });
}

class _FakeReleaseChecklistRepository implements ReleaseChecklistRepository {
  _FakeReleaseChecklistRepository(this._items);

  final List<ReleaseChecklistItem> _items;

  @override
  Future<List<ReleaseChecklistItem>> loadChecklist() async => _items;

  @override
  Future<void> saveChecklist(List<ReleaseChecklistItem> items) async {}
}
