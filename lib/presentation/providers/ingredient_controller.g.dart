// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientController)
const ingredientControllerProvider = IngredientControllerProvider._();

final class IngredientControllerProvider
    extends
        $AsyncNotifierProvider<IngredientController, List<PantryIngredient>> {
  const IngredientControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientControllerHash();

  @$internal
  @override
  IngredientController create() => IngredientController();
}

String _$ingredientControllerHash() =>
    r'53c25ec7aaa1f509c3ea7cef4332a38d2b33a0c5';

abstract class _$IngredientController
    extends $AsyncNotifier<List<PantryIngredient>> {
  FutureOr<List<PantryIngredient>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PantryIngredient>>, List<PantryIngredient>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PantryIngredient>>,
                List<PantryIngredient>
              >,
              AsyncValue<List<PantryIngredient>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
