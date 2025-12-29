// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_ai_recipe_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiRecipeService)
const aiRecipeServiceProvider = AiRecipeServiceProvider._();

final class AiRecipeServiceProvider
    extends
        $FunctionalProvider<AiRecipeService, AiRecipeService, AiRecipeService>
    with $Provider<AiRecipeService> {
  const AiRecipeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiRecipeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiRecipeServiceHash();

  @$internal
  @override
  $ProviderElement<AiRecipeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiRecipeService create(Ref ref) {
    return aiRecipeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiRecipeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiRecipeService>(value),
    );
  }
}

String _$aiRecipeServiceHash() => r'8f56bb99ddc20eff194f724fb2935a7f4f119d65';
