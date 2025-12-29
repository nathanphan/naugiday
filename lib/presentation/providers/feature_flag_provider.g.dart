// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(featureFlagRepository)
const featureFlagRepositoryProvider = FeatureFlagRepositoryProvider._();

final class FeatureFlagRepositoryProvider
    extends
        $FunctionalProvider<
          FeatureFlagRepository,
          FeatureFlagRepository,
          FeatureFlagRepository
        >
    with $Provider<FeatureFlagRepository> {
  const FeatureFlagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagRepositoryHash();

  @$internal
  @override
  $ProviderElement<FeatureFlagRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeatureFlagRepository create(Ref ref) {
    return featureFlagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureFlagRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureFlagRepository>(value),
    );
  }
}

String _$featureFlagRepositoryHash() =>
    r'cc2d7ec19b0313994d7910ced2d9f57f57b5edd4';

@ProviderFor(FeatureFlagController)
const featureFlagControllerProvider = FeatureFlagControllerProvider._();

final class FeatureFlagControllerProvider
    extends $AsyncNotifierProvider<FeatureFlagController, FeatureFlagState> {
  const FeatureFlagControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagControllerHash();

  @$internal
  @override
  FeatureFlagController create() => FeatureFlagController();
}

String _$featureFlagControllerHash() =>
    r'bd27e88f4b993f20d09b2d0a58e22ae4f93cdcff';

abstract class _$FeatureFlagController
    extends $AsyncNotifier<FeatureFlagState> {
  FutureOr<FeatureFlagState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<FeatureFlagState>, FeatureFlagState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FeatureFlagState>, FeatureFlagState>,
              AsyncValue<FeatureFlagState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
