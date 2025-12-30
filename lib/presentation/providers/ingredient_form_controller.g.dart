// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IngredientFormController)
const ingredientFormControllerProvider = IngredientFormControllerProvider._();

final class IngredientFormControllerProvider
    extends $NotifierProvider<IngredientFormController, IngredientFormState> {
  const IngredientFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientFormControllerHash();

  @$internal
  @override
  IngredientFormController create() => IngredientFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientFormState>(value),
    );
  }
}

String _$ingredientFormControllerHash() =>
    r'd4fb52864d6a82197e3d67c079a3c5a83644d71c';

abstract class _$IngredientFormController
    extends $Notifier<IngredientFormState> {
  IngredientFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IngredientFormState, IngredientFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<IngredientFormState, IngredientFormState>,
              IngredientFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
