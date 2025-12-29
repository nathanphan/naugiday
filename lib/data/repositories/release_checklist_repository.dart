import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';
import 'package:naugiday/domain/entities/release_checklist_item.dart';
import 'package:naugiday/domain/repositories/release_checklist_repository.dart';
import 'package:uuid/uuid.dart';

class ReleaseChecklistRepositoryImpl implements ReleaseChecklistRepository {
  final _uuid = const Uuid();

  @override
  Future<List<ReleaseChecklistItem>> loadChecklist() async {
    final box = Hive.box(releaseChecklistBoxName);
    final stored = box.get('items') as List<dynamic>?;
    if (stored == null || stored.isEmpty) {
      final items = defaultReleaseChecklistItems
          .map(
            (title) => ReleaseChecklistItem(
              id: _uuid.v4(),
              title: title,
              status: 'pending',
            ),
          )
          .toList();
      await saveChecklist(items);
      return items;
    }
    return stored
        .map(
          (item) => ReleaseChecklistItemRecord.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .map(
          (record) => ReleaseChecklistItem(
            id: record.id,
            title: record.title,
            status: record.status,
            owner: record.owner,
            notes: record.notes,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveChecklist(List<ReleaseChecklistItem> items) async {
    final box = Hive.box(releaseChecklistBoxName);
    final stored = items
        .map(
          (item) => ReleaseChecklistItemRecord(
            id: item.id,
            title: item.title,
            status: item.status,
            owner: item.owner,
            notes: item.notes,
          ).toJson(),
        )
        .toList();
    await box.put('items', stored);
  }
}
