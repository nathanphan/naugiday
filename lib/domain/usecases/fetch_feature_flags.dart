import 'package:naugiday/domain/entities/feature_flag.dart';
import 'package:naugiday/domain/repositories/feature_flag_repository.dart';

class FetchFeatureFlags {
  final FeatureFlagRepository _repository;

  FetchFeatureFlags(this._repository);

  Future<List<FeatureFlag>> call() async {
    try {
      final flags = await _repository.fetchRemoteFlags();
      await _repository.cacheFlags(flags);
      return flags;
    } catch (_) {
      return _repository.getCachedFlags();
    }
  }
}
