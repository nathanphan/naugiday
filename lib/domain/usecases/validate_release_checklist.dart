import 'package:naugiday/domain/entities/release_checklist_item.dart';
import 'package:naugiday/domain/repositories/release_checklist_repository.dart';

class ValidateReleaseChecklist {
  final ReleaseChecklistRepository _repository;

  ValidateReleaseChecklist(this._repository);

  Future<bool> call() async {
    final items = await _repository.loadChecklist();
    return items.every((item) => item.status == 'complete');
  }

  bool validateItems(List<ReleaseChecklistItem> items) {
    return items.every((item) => item.status == 'complete');
  }
}
