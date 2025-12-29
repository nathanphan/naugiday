import 'package:naugiday/data/repositories/feature_flag_repository.dart';
import 'package:naugiday/data/services/remote_config_service.dart';
import 'package:naugiday/domain/entities/feature_flag.dart';
import 'package:naugiday/domain/repositories/feature_flag_repository.dart';
import 'package:naugiday/domain/usecases/fetch_feature_flags.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flag_provider.g.dart';

class FeatureFlagState {
  final bool aiEnabled;
  final bool imagesEnabled;
  final DateTime updatedAt;
  final String source;

  const FeatureFlagState({
    required this.aiEnabled,
    required this.imagesEnabled,
    required this.updatedAt,
    required this.source,
  });

  factory FeatureFlagState.fromFlags(List<FeatureFlag> flags) {
    final aiFlag = flags.firstWhere((f) => f.name == 'ai_enabled');
    final imageFlag = flags.firstWhere((f) => f.name == 'images_enabled');
    return FeatureFlagState(
      aiEnabled: aiFlag.enabled,
      imagesEnabled: imageFlag.enabled,
      updatedAt: aiFlag.updatedAt,
      source: aiFlag.source,
    );
  }
}

@riverpod
FeatureFlagRepository featureFlagRepository(Ref ref) {
  return FeatureFlagRepositoryImpl(RemoteConfigService());
}

@riverpod
class FeatureFlagController extends _$FeatureFlagController {
  late final FeatureFlagRepository _repository;
  late final FetchFeatureFlags _fetchFlags;

  @override
  Future<FeatureFlagState> build() async {
    _repository = ref.watch(featureFlagRepositoryProvider);
    _fetchFlags = FetchFeatureFlags(_repository);
    final flags = await _fetchFlags();
    return FeatureFlagState.fromFlags(flags);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final flags = await _fetchFlags();
      if (!ref.mounted) return;
      state = AsyncData(FeatureFlagState.fromFlags(flags));
    } catch (err, stack) {
      if (!ref.mounted) return;
      state = AsyncError(err, stack);
    }
  }
}
