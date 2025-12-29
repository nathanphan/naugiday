import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/release_checklist_item.dart';
import 'package:naugiday/domain/repositories/release_checklist_repository.dart';
import 'package:naugiday/domain/usecases/validate_release_checklist.dart';

class _FakeReleaseChecklistRepository implements ReleaseChecklistRepository {
  _FakeReleaseChecklistRepository(this.items);

  final List<ReleaseChecklistItem> items;

  @override
  Future<List<ReleaseChecklistItem>> loadChecklist() async => items;

  @override
  Future<void> saveChecklist(List<ReleaseChecklistItem> items) async {}
}

void main() {
  test('validateItems returns true when all complete', () {
    final items = [
      ReleaseChecklistItem(id: '1', title: 'A', status: 'complete'),
      ReleaseChecklistItem(id: '2', title: 'B', status: 'complete'),
    ];
    final validator = ValidateReleaseChecklist(
      _FakeReleaseChecklistRepository(items),
    );
    expect(validator.validateItems(items), isTrue);
  });

  test('validateItems returns false when any pending', () {
    final items = [
      ReleaseChecklistItem(id: '1', title: 'A', status: 'complete'),
      ReleaseChecklistItem(id: '2', title: 'B', status: 'pending'),
    ];
    final validator = ValidateReleaseChecklist(
      _FakeReleaseChecklistRepository(items),
    );
    expect(validator.validateItems(items), isFalse);
  });
}
