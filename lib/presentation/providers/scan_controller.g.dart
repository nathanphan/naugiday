// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scanQueueRepository)
const scanQueueRepositoryProvider = ScanQueueRepositoryProvider._();

final class ScanQueueRepositoryProvider
    extends
        $FunctionalProvider<
          ScanQueueRepository,
          ScanQueueRepository,
          ScanQueueRepository
        >
    with $Provider<ScanQueueRepository> {
  const ScanQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanQueueRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanQueueRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScanQueueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanQueueRepository create(Ref ref) {
    return scanQueueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanQueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanQueueRepository>(value),
    );
  }
}

String _$scanQueueRepositoryHash() =>
    r'd5471d4f0ccdcf2f06d32afe216517759f107af7';

@ProviderFor(scanPermissionRepository)
const scanPermissionRepositoryProvider = ScanPermissionRepositoryProvider._();

final class ScanPermissionRepositoryProvider
    extends
        $FunctionalProvider<
          ScanPermissionRepository,
          ScanPermissionRepository,
          ScanPermissionRepository
        >
    with $Provider<ScanPermissionRepository> {
  const ScanPermissionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanPermissionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanPermissionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScanPermissionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanPermissionRepository create(Ref ref) {
    return scanPermissionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanPermissionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanPermissionRepository>(value),
    );
  }
}

String _$scanPermissionRepositoryHash() =>
    r'edcf75f2e204eb76aa4fbc70380809b94d0e5176';

@ProviderFor(scanImagePicker)
const scanImagePickerProvider = ScanImagePickerProvider._();

final class ScanImagePickerProvider
    extends
        $FunctionalProvider<ScanImagePicker, ScanImagePicker, ScanImagePicker>
    with $Provider<ScanImagePicker> {
  const ScanImagePickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanImagePickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanImagePickerHash();

  @$internal
  @override
  $ProviderElement<ScanImagePicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScanImagePicker create(Ref ref) {
    return scanImagePicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanImagePicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanImagePicker>(value),
    );
  }
}

String _$scanImagePickerHash() => r'cb129ed77c84fd5b85d97af2768502dab95b69fc';

@ProviderFor(scanNetworkLookup)
const scanNetworkLookupProvider = ScanNetworkLookupProvider._();

final class ScanNetworkLookupProvider
    extends
        $FunctionalProvider<
          ScanNetworkLookup,
          ScanNetworkLookup,
          ScanNetworkLookup
        >
    with $Provider<ScanNetworkLookup> {
  const ScanNetworkLookupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanNetworkLookupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanNetworkLookupHash();

  @$internal
  @override
  $ProviderElement<ScanNetworkLookup> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScanNetworkLookup create(Ref ref) {
    return scanNetworkLookup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanNetworkLookup value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanNetworkLookup>(value),
    );
  }
}

String _$scanNetworkLookupHash() => r'0bed5a963297e8e47eda8c10ce4106db9c87bf19';

@ProviderFor(ScanController)
const scanControllerProvider = ScanControllerProvider._();

final class ScanControllerProvider
    extends $NotifierProvider<ScanController, ScanControllerState> {
  const ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanControllerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanControllerState>(value),
    );
  }
}

String _$scanControllerHash() => r'649c861025bd82aaad488e71abc6ba756dd75134';

abstract class _$ScanController extends $Notifier<ScanControllerState> {
  ScanControllerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ScanControllerState, ScanControllerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanControllerState, ScanControllerState>,
              ScanControllerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
