// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeController)
const recipeControllerProvider = RecipeControllerProvider._();

final class RecipeControllerProvider
    extends $AsyncNotifierProvider<RecipeController, List<Recipe>> {
  const RecipeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeControllerHash();

  @$internal
  @override
  RecipeController create() => RecipeController();
}

String _$recipeControllerHash() => r'46083e4fa3c7907ba2a6bc93291bb305655656d8';

abstract class _$RecipeController extends $AsyncNotifier<List<Recipe>> {
  FutureOr<List<Recipe>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Recipe>>, List<Recipe>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Recipe>>, List<Recipe>>,
              AsyncValue<List<Recipe>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
