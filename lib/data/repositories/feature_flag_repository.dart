import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';
import 'package:naugiday/data/services/remote_config_service.dart';
import 'package:naugiday/domain/entities/feature_flag.dart';
import 'package:naugiday/domain/repositories/feature_flag_repository.dart';

class FeatureFlagRepositoryImpl implements FeatureFlagRepository {
  FeatureFlagRepositoryImpl(this._remoteConfigService);

  final RemoteConfigService _remoteConfigService;

  @override
  Future<List<FeatureFlag>> fetchRemoteFlags() async {
    final record = await _remoteConfigService.fetchFeatureFlags(
      fallback: _readCachedRecord(),
    );
    return _toFlags(record, source: 'remote');
  }

  @override
  Future<List<FeatureFlag>> getCachedFlags() async {
    final cached = _readCachedRecord();
    if (cached == null) {
      return _toFlags(
        FeatureFlagRecord(
          aiEnabled: true,
          imagesEnabled: true,
          ingredientsEnabled: true,
          ingredientPhotosEnabled: true,
          scanEnabled: true,
          updatedAt: DateTime.now(),
        ),
        source: 'cache',
      );
    }
    return _toFlags(cached, source: 'cache');
  }

  @override
  Future<void> cacheFlags(List<FeatureFlag> flags) async {
    final record = FeatureFlagRecord(
      aiEnabled: flags.firstWhere((f) => f.name == 'ai_enabled').enabled,
      imagesEnabled:
          flags.firstWhere((f) => f.name == 'images_enabled').enabled,
      ingredientsEnabled: flags
          .firstWhere(
            (f) => f.name == 'ingredients_enabled',
            orElse: () => FeatureFlag(
              name: 'ingredients_enabled',
              enabled: true,
              source: 'cache',
              updatedAt: DateTime.now(),
            ),
          )
          .enabled,
      ingredientPhotosEnabled: flags
          .firstWhere(
            (f) => f.name == 'ingredient_photos_enabled',
            orElse: () => FeatureFlag(
              name: 'ingredient_photos_enabled',
              enabled: true,
              source: 'cache',
              updatedAt: DateTime.now(),
            ),
          )
          .enabled,
      scanEnabled: flags
          .firstWhere(
            (f) => f.name == 'scan_enabled',
            orElse: () => FeatureFlag(
              name: 'scan_enabled',
              enabled: true,
              source: 'cache',
              updatedAt: DateTime.now(),
            ),
          )
          .enabled,
      updatedAt: DateTime.now(),
    );
    final box = Hive.box(featureFlagsBoxName);
    await box.put('flags', record.toJson());
  }

  List<FeatureFlag> _toFlags(FeatureFlagRecord record, {required String source}) {
    return [
      FeatureFlag(
        name: 'ai_enabled',
        enabled: record.aiEnabled,
        source: source,
        updatedAt: record.updatedAt,
      ),
      FeatureFlag(
        name: 'images_enabled',
        enabled: record.imagesEnabled,
        source: source,
        updatedAt: record.updatedAt,
      ),
      FeatureFlag(
        name: 'ingredients_enabled',
        enabled: record.ingredientsEnabled,
        source: source,
        updatedAt: record.updatedAt,
      ),
      FeatureFlag(
        name: 'ingredient_photos_enabled',
        enabled: record.ingredientPhotosEnabled,
        source: source,
        updatedAt: record.updatedAt,
      ),
      FeatureFlag(
        name: 'scan_enabled',
        enabled: record.scanEnabled,
        source: source,
        updatedAt: record.updatedAt,
      ),
    ];
  }

  FeatureFlagRecord? _readCachedRecord() {
    final box = Hive.box(featureFlagsBoxName);
    final cached = box.get('flags') as Map<String, dynamic>?;
    if (cached == null) return null;
    return FeatureFlagRecord.fromJson(cached);
  }
}
