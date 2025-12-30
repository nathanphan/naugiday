import 'package:naugiday/domain/entities/ingredient_category.dart';
import 'package:naugiday/domain/entities/pantry_ingredient.dart';
import 'package:naugiday/domain/usecases/list_categories.dart';
import 'package:naugiday/presentation/providers/ingredient_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ingredient_filters_provider.g.dart';

class IngredientFiltersState {
  final String query;
  final Set<String> categoryIds;
  final Set<IngredientInventoryState> inventoryStates;

  const IngredientFiltersState({
    this.query = '',
    this.categoryIds = const {},
    this.inventoryStates = const {},
  });

  IngredientFiltersState copyWith({
    String? query,
    Set<String>? categoryIds,
    Set<IngredientInventoryState>? inventoryStates,
  }) {
    return IngredientFiltersState(
      query: query ?? this.query,
      categoryIds: categoryIds ?? this.categoryIds,
      inventoryStates: inventoryStates ?? this.inventoryStates,
    );
  }
}

@riverpod
class IngredientFilters extends _$IngredientFilters {
  @override
  IngredientFiltersState build() => const IngredientFiltersState();

  void setQuery(String value) {
    state = state.copyWith(query: value);
  }

  void toggleCategory(String categoryId) {
    final updated = state.categoryIds.toSet();
    if (!updated.add(categoryId)) {
      updated.remove(categoryId);
    }
    state = state.copyWith(categoryIds: updated);
  }

  void clearCategories() {
    state = state.copyWith(categoryIds: {});
  }

  void toggleInventoryState(IngredientInventoryState value) {
    final updated = state.inventoryStates.toSet();
    if (!updated.add(value)) {
      updated.remove(value);
    }
    state = state.copyWith(inventoryStates: updated);
  }

  void clear() {
    state = const IngredientFiltersState();
  }
}

@riverpod
Future<List<IngredientCategory>> ingredientCategories(Ref ref) async {
  final repository = ref.watch(ingredientRepositoryProvider);
  final listCategories = ListCategories(repository);
  return listCategories();
}
