import 'package:naugiday/domain/entities/bulk_ingredient_update.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/repositories/ingredient_repository.dart';
import 'package:naugiday/domain/usecases/bulk_update_ingredients.dart';
import 'package:naugiday/domain/usecases/delete_ingredient.dart';
import 'package:naugiday/domain/usecases/get_ingredient.dart';
import 'package:naugiday/domain/usecases/list_ingredients.dart';
import 'package:naugiday/domain/usecases/save_ingredient.dart';
import 'package:naugiday/domain/usecases/update_ingredient.dart';
import 'package:naugiday/presentation/providers/ingredient_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_controller.g.dart';

@Riverpod(keepAlive: true)
class IngredientController extends _$IngredientController {
  late final IngredientRepository _repository;
  late final ListIngredients _listIngredients;
  late final GetIngredient _getIngredient;
  late final SaveIngredient _saveIngredient;
  late final UpdateIngredient _updateIngredient;
  late final DeleteIngredient _deleteIngredient;
  late final BulkUpdateIngredients _bulkUpdate;

  @override
  Future<List<PantryIngredient>> build() async {
    _repository = ref.watch(ingredientRepositoryProvider);
    _listIngredients = ListIngredients(_repository);
    _getIngredient = GetIngredient(_repository);
    _saveIngredient = SaveIngredient(_repository);
    _updateIngredient = UpdateIngredient(_repository);
    _deleteIngredient = DeleteIngredient(_repository);
    _bulkUpdate = BulkUpdateIngredients(_repository);
    return _listIngredients();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final ingredients = await _listIngredients();
      if (!ref.mounted) return;
      state = AsyncData(ingredients);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<PantryIngredient>>(err, stack);
    }
  }

  Future<PantryIngredient?> fetchIngredient(String id) {
    return _getIngredient(id);
  }

  Future<void> addIngredient(PantryIngredient ingredient) async {
    await _runAndReload(() => _saveIngredient(ingredient));
  }

  Future<void> updateIngredient(PantryIngredient ingredient) async {
    await _runAndReload(() => _updateIngredient(ingredient));
  }

  Future<void> deleteIngredient(String id) async {
    await _runAndReload(() => _deleteIngredient(id));
  }

  Future<void> applyBulkUpdate(BulkIngredientUpdate update) async {
    await _runAndReload(() => _bulkUpdate(update));
  }

  Future<void> recoverStorage() async {
    state = const AsyncLoading();
    try {
      final ingredients = await _repository.recoverCorruptedEntries();
      if (!ref.mounted) return;
      state = AsyncData(ingredients);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<PantryIngredient>>(err, stack);
    }
  }

  Future<void> _runAndReload(Future<void> Function() action) async {
    try {
      await action();
      final ingredients = await _listIngredients();
      if (!ref.mounted) return;
      state = AsyncData(ingredients);
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError<List<PantryIngredient>>(err, stack);
    }
  }
}
