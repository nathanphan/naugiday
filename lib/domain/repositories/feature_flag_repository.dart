import 'package:naugiday/domain/entities/feature_flag.dart';

abstract class FeatureFlagRepository {
  Future<List<FeatureFlag>> fetchRemoteFlags();
  Future<List<FeatureFlag>> getCachedFlags();
  Future<void> cacheFlags(List<FeatureFlag> flags);
}
