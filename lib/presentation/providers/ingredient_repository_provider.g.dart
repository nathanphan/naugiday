// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ingredientRepository)
const ingredientRepositoryProvider = IngredientRepositoryProvider._();

final class IngredientRepositoryProvider
    extends
        $FunctionalProvider<
          IngredientRepository,
          IngredientRepository,
          IngredientRepository
        >
    with $Provider<IngredientRepository> {
  const IngredientRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientRepositoryHash();

  @$internal
  @override
  $ProviderElement<IngredientRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IngredientRepository create(Ref ref) {
    return ingredientRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientRepository>(value),
    );
  }
}

String _$ingredientRepositoryHash() =>
    r'd8d52bd229423b03479b475e7a7f6506fedf1c75';
