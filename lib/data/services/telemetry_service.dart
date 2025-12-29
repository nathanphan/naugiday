import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:naugiday/core/constants/launch_hardening_constants.dart';
import 'package:naugiday/data/models/launch_hardening_models.dart';

class TelemetryService {
  final HttpClient _client;
  final String _baseUrl;

  TelemetryService({HttpClient? client, String? baseUrl})
      : _client = client ?? HttpClient(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(proxyBaseUrlEnv, defaultValue: '');

  Future<void> enqueueEvent(TelemetryEventRecord event) async {
    if (!Hive.isBoxOpen(telemetryQueueBoxName)) {
      return;
    }
    final box = Hive.box(telemetryQueueBoxName);
    final existing = box.get('queue') as List<dynamic>? ?? <dynamic>[];
    final updated = List<Map<String, dynamic>>.from(existing)
      ..add(event.toJson());
    await box.put('queue', updated);
  }

  Future<void> flushPending() async {
    if (!Hive.isBoxOpen(telemetryQueueBoxName)) {
      return;
    }
    final box = Hive.box(telemetryQueueBoxName);
    final existing = box.get('queue') as List<dynamic>? ?? <dynamic>[];
    if (existing.isEmpty) return;
    final payload = {
      'events': existing,
    };
    await _send(payload);
    await box.put('queue', <dynamic>[]);
  }

  Future<void> sendEventBatch(List<TelemetryEventRecord> events) async {
    if (events.isEmpty) return;
    final payload = {
      'events': events.map((event) => event.toJson()).toList(),
    };
    await _send(payload);
  }

  Future<void> _send(Map<String, dynamic> payload) async {
    if (_baseUrl.isEmpty) {
      throw const SocketException('Telemetry base URL not configured');
    }
    final uri = Uri.parse('$_baseUrl$telemetryPath');
    final request = await _client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.add(utf8.encode(jsonEncode(payload)));
    final response = await request.close();
    if (response.statusCode != HttpStatus.accepted &&
        response.statusCode != HttpStatus.ok) {
      throw HttpException('Telemetry rejected: ${response.statusCode}');
    }
  }
}
