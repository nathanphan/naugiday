import 'package:naugiday/data/repositories/release_checklist_repository.dart';
import 'package:naugiday/domain/entities/release_checklist_item.dart';
import 'package:naugiday/domain/repositories/release_checklist_repository.dart';
import 'package:naugiday/domain/usecases/validate_release_checklist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_checklist_provider.g.dart';

@riverpod
ReleaseChecklistRepository releaseChecklistRepository(Ref ref) {
  return ReleaseChecklistRepositoryImpl();
}

@riverpod
class ReleaseChecklistController extends _$ReleaseChecklistController {
  late final ReleaseChecklistRepository _repository;
  late final ValidateReleaseChecklist _validator;

  @override
  Future<List<ReleaseChecklistItem>> build() async {
    _repository = ref.watch(releaseChecklistRepositoryProvider);
    _validator = ValidateReleaseChecklist(_repository);
    return _repository.loadChecklist();
  }

  Future<void> toggleItem(String id, bool isComplete) async {
    final items = state.value ?? await _repository.loadChecklist();
    final updated = items
        .map(
          (item) => item.id == id
              ? item.copyWith(status: isComplete ? 'complete' : 'pending')
              : item,
        )
        .toList();
    await _repository.saveChecklist(updated);
    if (!ref.mounted) return;
    state = AsyncData(updated);
  }

  Future<bool> validateChecklist() async {
    final items = state.value ?? await _repository.loadChecklist();
    return _validator.validateItems(items);
  }
}
