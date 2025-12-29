// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_checklist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(releaseChecklistRepository)
const releaseChecklistRepositoryProvider =
    ReleaseChecklistRepositoryProvider._();

final class ReleaseChecklistRepositoryProvider
    extends
        $FunctionalProvider<
          ReleaseChecklistRepository,
          ReleaseChecklistRepository,
          ReleaseChecklistRepository
        >
    with $Provider<ReleaseChecklistRepository> {
  const ReleaseChecklistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseChecklistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseChecklistRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReleaseChecklistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReleaseChecklistRepository create(Ref ref) {
    return releaseChecklistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleaseChecklistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleaseChecklistRepository>(value),
    );
  }
}

String _$releaseChecklistRepositoryHash() =>
    r'0bd524cad4e666017c217dbd64da47d83fe1fdb8';

@ProviderFor(ReleaseChecklistController)
const releaseChecklistControllerProvider =
    ReleaseChecklistControllerProvider._();

final class ReleaseChecklistControllerProvider
    extends
        $AsyncNotifierProvider<
          ReleaseChecklistController,
          List<ReleaseChecklistItem>
        > {
  const ReleaseChecklistControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseChecklistControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseChecklistControllerHash();

  @$internal
  @override
  ReleaseChecklistController create() => ReleaseChecklistController();
}

String _$releaseChecklistControllerHash() =>
    r'7873b4f4a392034850ea9cc55156d3589ab994ed';

abstract class _$ReleaseChecklistController
    extends $AsyncNotifier<List<ReleaseChecklistItem>> {
  FutureOr<List<ReleaseChecklistItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ReleaseChecklistItem>>,
              List<ReleaseChecklistItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReleaseChecklistItem>>,
                List<ReleaseChecklistItem>
              >,
              AsyncValue<List<ReleaseChecklistItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
