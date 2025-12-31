# Quickstart: Scan UX States

## Prerequisites

- iOS simulator or device (iOS 15+)
- Camera permission available (or toggled off for denied state testing)

## Build & Test

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

Targeted tests (if you want to run only scan coverage):

```bash
flutter test test/widget/scan_camera_unavailable_test.dart
flutter test test/widget/scan_label_propagation_test.dart
flutter test integration_test
```

## Manual QA Scenarios

1. **Normal state**
   - Open scan screen.
   - Capture a photo and verify preview + CTAs.
   - Pick an image from gallery and verify preview.

2. **Initializing state**
   - Set `DebugToggles.cameraMode = CameraDebugMode.slow` in debug builds.
   - Open scan screen and verify skeleton/loading UI.

3. **Camera unavailable**
   - Set `DebugToggles.cameraMode = CameraDebugMode.unavailable`.
   - Verify fallback UI, retry action, and gallery fallback if enabled.

4. **Permission denied**
   - Deny camera permission in iOS Settings.
   - Open scan screen and verify guidance steps + Settings deep link.
   - Use gallery fallback when permitted.

5. **Disabled state**
   - Toggle feature flag `scan_enabled` to false (via remote flags or local debug overrides).
   - Verify disabled UI with alternate entry points.

6. **Offline queue**
   - Enable airplane mode.
   - Capture or pick an image and confirm it is queued for later processing.

## Performance Profiling Notes

- Verify scan screen reaches interactive state in <=2 seconds (p95 target).
- Confirm camera preview and overlays stay within 16ms frame budget while toggling flash and opening the preview sheet.
- Record any deviations and the device model used.

## Notes

- Ensure App Store purpose strings are present for camera and photo access.
- Confirm analytics events are recorded without PII.
