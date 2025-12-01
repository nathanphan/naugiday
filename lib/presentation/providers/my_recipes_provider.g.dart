// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_recipes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyRecipes)
const myRecipesProvider = MyRecipesProvider._();

final class MyRecipesProvider
    extends $AsyncNotifierProvider<MyRecipes, List<Recipe>> {
  const MyRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRecipesHash();

  @$internal
  @override
  MyRecipes create() => MyRecipes();
}

String _$myRecipesHash() => r'c3c7711a5bb528e9f0f14622ceaab4e16cc6cb3d';

abstract class _$MyRecipes extends $AsyncNotifier<List<Recipe>> {
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
