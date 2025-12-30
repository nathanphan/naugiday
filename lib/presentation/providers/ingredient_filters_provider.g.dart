// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_filters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientFilters)
const ingredientFiltersProvider = IngredientFiltersProvider._();

final class IngredientFiltersProvider
    extends $NotifierProvider<IngredientFilters, IngredientFiltersState> {
  const IngredientFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientFiltersHash();

  @$internal
  @override
  IngredientFilters create() => IngredientFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientFiltersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientFiltersState>(value),
    );
  }
}

String _$ingredientFiltersHash() => r'87fa0520e193efd8a5332d232af2fb05b269c212';

abstract class _$IngredientFilters extends $Notifier<IngredientFiltersState> {
  IngredientFiltersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<IngredientFiltersState, IngredientFiltersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IngredientFiltersState, IngredientFiltersState>,
              IngredientFiltersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ingredientCategories)
const ingredientCategoriesProvider = IngredientCategoriesProvider._();

final class IngredientCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientCategory>>,
          List<IngredientCategory>,
          FutureOr<List<IngredientCategory>>
        >
    with
        $FutureModifier<List<IngredientCategory>>,
        $FutureProvider<List<IngredientCategory>> {
  const IngredientCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<IngredientCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IngredientCategory>> create(Ref ref) {
    return ingredientCategories(ref);
  }
}

String _$ingredientCategoriesHash() =>
    r'3e6fdb2982963c68bca4a7e66096deff5d1ac6c4';
