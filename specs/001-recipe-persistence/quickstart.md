# Quickstart — Persistent Local Recipe Storage

## Prerequisites
- Flutter SDK (stable channel)
- Run `flutter pub get`

## Build & Codegen
- `dart run build_runner build --delete-conflicting-outputs` (keeps Freezed/Riverpod/Hive adapters in sync)

## Run
- `flutter run` (select iOS simulator or Android emulator)
- On first launch, Hive adapters register automatically; recipes box migrates old string entries to typed DTOs.

## Test
- `flutter test` (unit + widget)
- Add parsing/contract tests for persistence adapters when data shapes change.
- Integrity suite: `flutter test test/data/recipe_recovery_test.dart test/widget/recipe_error_retry_test.dart`

## Notes
- Verify offline behavior by disabling network and confirming recipe save/open flows work end-to-end (save, reopen, edit, delete).
- Recovery UI surfaces if Hive encounters corrupted entries; use “Repair storage” and retry.
- Ensure secrets (API keys) are passed via `--dart-define` and not persisted with recipes.
