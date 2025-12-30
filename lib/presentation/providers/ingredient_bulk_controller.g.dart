// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_bulk_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientBulkController)
const ingredientBulkControllerProvider = IngredientBulkControllerProvider._();

final class IngredientBulkControllerProvider
    extends $NotifierProvider<IngredientBulkController, IngredientBulkState> {
  const IngredientBulkControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientBulkControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientBulkControllerHash();

  @$internal
  @override
  IngredientBulkController create() => IngredientBulkController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientBulkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientBulkState>(value),
    );
  }
}

String _$ingredientBulkControllerHash() =>
    r'32f556e6b511161a3fd7897cc7cec66e079d5388';

abstract class _$IngredientBulkController
    extends $Notifier<IngredientBulkState> {
  IngredientBulkState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IngredientBulkState, IngredientBulkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IngredientBulkState, IngredientBulkState>,
              IngredientBulkState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
