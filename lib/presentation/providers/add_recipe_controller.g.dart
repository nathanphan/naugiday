// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_recipe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddRecipeController)
const addRecipeControllerProvider = AddRecipeControllerProvider._();

final class AddRecipeControllerProvider
    extends $NotifierProvider<AddRecipeController, AddRecipeState> {
  const AddRecipeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addRecipeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addRecipeControllerHash();

  @$internal
  @override
  AddRecipeController create() => AddRecipeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddRecipeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddRecipeState>(value),
    );
  }
}

String _$addRecipeControllerHash() =>
    r'3418fd3bbc76baf7fe5a932bdec1b6a0a67a5975';

abstract class _$AddRecipeController extends $Notifier<AddRecipeState> {
  AddRecipeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AddRecipeState, AddRecipeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddRecipeState, AddRecipeState>,
              AddRecipeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
