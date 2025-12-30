import 'dart:convert';
import 'dart:io';

import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';

class RemoteConfigService {
  final HttpClient _client;
  final String _baseUrl;

  RemoteConfigService({HttpClient? client, String? baseUrl})
      : _client = client ?? HttpClient(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(proxyBaseUrlEnv, defaultValue: '');

  Future<FeatureFlagRecord> fetchFeatureFlags({
    FeatureFlagRecord? fallback,
  }) async {
    if (_baseUrl.isEmpty) {
      return FeatureFlagRecord(
        aiEnabled: true,
        imagesEnabled: true,
        ingredientsEnabled: true,
        updatedAt: DateTime.now(),
      );
    }
    try {
      final uri = Uri.parse('$_baseUrl$remoteConfigPath');
      final request = await _client.getUrl(uri);
      request.headers.set('Accept', 'application/json');
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Failed to fetch flags: ${response.statusCode}');
      }
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      return FeatureFlagRecord.fromJson(json);
    } on SocketException {
      if (fallback != null) return fallback;
      rethrow;
    }
  }
}
