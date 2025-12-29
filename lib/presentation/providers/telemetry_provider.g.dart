// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(telemetryRepository)
const telemetryRepositoryProvider = TelemetryRepositoryProvider._();

final class TelemetryRepositoryProvider
    extends
        $FunctionalProvider<
          TelemetryRepository,
          TelemetryRepository,
          TelemetryRepository
        >
    with $Provider<TelemetryRepository> {
  const TelemetryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryRepositoryHash();

  @$internal
  @override
  $ProviderElement<TelemetryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TelemetryRepository create(Ref ref) {
    return telemetryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelemetryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelemetryRepository>(value),
    );
  }
}

String _$telemetryRepositoryHash() =>
    r'1042fa0ee959e1c56f89acbad878b316531adb2d';

@ProviderFor(TelemetryController)
const telemetryControllerProvider = TelemetryControllerProvider._();

final class TelemetryControllerProvider
    extends $NotifierProvider<TelemetryController, bool> {
  const TelemetryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryControllerHash();

  @$internal
  @override
  TelemetryController create() => TelemetryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$telemetryControllerHash() =>
    r'77814915c120f7e4112f8840bd1db9eb462a78b0';

abstract class _$TelemetryController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
