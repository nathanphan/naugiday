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
    r'91e9be00a78adca0b8200d3d031bae3835f8bfa9';

@ProviderFor(ingredientPhotoStorage)
const ingredientPhotoStorageProvider = IngredientPhotoStorageProvider._();

final class IngredientPhotoStorageProvider
    extends
        $FunctionalProvider<
          IngredientPhotoStorage,
          IngredientPhotoStorage,
          IngredientPhotoStorage
        >
    with $Provider<IngredientPhotoStorage> {
  const IngredientPhotoStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientPhotoStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientPhotoStorageHash();

  @$internal
  @override
  $ProviderElement<IngredientPhotoStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IngredientPhotoStorage create(Ref ref) {
    return ingredientPhotoStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientPhotoStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientPhotoStorage>(value),
    );
  }
}

String _$ingredientPhotoStorageHash() =>
    r'96380ffa7dd44db2392e394c019a3d0a23593e58';

@ProviderFor(ingredientPhotoPicker)
const ingredientPhotoPickerProvider = IngredientPhotoPickerProvider._();

final class IngredientPhotoPickerProvider
    extends
        $FunctionalProvider<
          IngredientPhotoPicker,
          IngredientPhotoPicker,
          IngredientPhotoPicker
        >
    with $Provider<IngredientPhotoPicker> {
  const IngredientPhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientPhotoPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientPhotoPickerHash();

  @$internal
  @override
  $ProviderElement<IngredientPhotoPicker> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IngredientPhotoPicker create(Ref ref) {
    return ingredientPhotoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientPhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientPhotoPicker>(value),
    );
  }
}

String _$ingredientPhotoPickerHash() =>
    r'1edd08a0199bb4573516819b78fd25a072e4a15d';
