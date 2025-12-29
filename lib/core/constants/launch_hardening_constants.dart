const String privacyPolicyUrl = 'https://example.com/privacy';
const String appPrivacySummary = 'No personal data is collected.';

const String remoteConfigPath = '/v1/feature-flags';
const String telemetryPath = '/v1/telemetry/events';

const String proxyBaseUrlEnv = 'PROXY_BASE_URL';

const String featureFlagsBoxName = 'feature_flags';
const String telemetryQueueBoxName = 'telemetry_queue';
const String releaseChecklistBoxName = 'release_checklist';

const List<String> defaultReleaseChecklistItems = [
  'Purpose strings configured (Camera/Photos)',
  'Privacy policy URL available in-app',
  'App Privacy details reviewed',
  'Crash reporting enabled (PII-safe)',
  'Minimal analytics configured',
  'Kill switches validated (AI + Images)',
  'Accessibility pass (VoiceOver/tap targets)',
  'Performance budget checklist complete',
  'Rollback plan reviewed',
];
