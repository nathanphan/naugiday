import 'package:naugiday/domain/entities/release_checklist_item.dart';

abstract class ReleaseChecklistRepository {
  Future<List<ReleaseChecklistItem>> loadChecklist();
  Future<void> saveChecklist(List<ReleaseChecklistItem> items);
}
