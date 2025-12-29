import 'package:flutter_test/flutter_test.dart';
import 'package:naugiday/domain/entities/feature_flag.dart';
import 'package:naugiday/domain/repositories/feature_flag_repository.dart';
import 'package:naugiday/domain/usecases/fetch_feature_flags.dart';

class _FakeFeatureFlagRepository implements FeatureFlagRepository {
  _FakeFeatureFlagRepository({required this.cached, this.shouldFail = false});

  final List<FeatureFlag> cached;
  final bool shouldFail;

  @override
  Future<void> cacheFlags(List<FeatureFlag> flags) async {}

  @override
  Future<List<FeatureFlag>> fetchRemoteFlags() async {
    if (shouldFail) {
      throw Exception('network failed');
    }
    return cached;
  }

  @override
  Future<List<FeatureFlag>> getCachedFlags() async => cached;
}

void main() {
  test('falls back to cached flags when remote fails', () async {
    final cached = [
      FeatureFlag(
        name: 'ai_enabled',
        enabled: false,
        source: 'cache',
        updatedAt: DateTime(2025, 1, 1),
      ),
      FeatureFlag(
        name: 'images_enabled',
        enabled: true,
        source: 'cache',
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];
    final repo = _FakeFeatureFlagRepository(cached: cached, shouldFail: true);
    final usecase = FetchFeatureFlags(repo);

    final result = await usecase();

    expect(result, cached);
  });
}
