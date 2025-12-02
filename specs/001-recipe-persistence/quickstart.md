# Quickstart — Persistent Local Recipe Storage

## Prerequisites
- Flutter SDK (stable channel)
- Run `flutter pub get`

## Build & Codegen
- `dart run build_runner build --delete-conflicting-outputs` (keeps Freezed/Riverpod/Hive adapters in sync)

## Run
- `flutter run` (select iOS simulator or Android emulator)

## Test
- `flutter test` (unit + widget)
- Add parsing/contract tests for persistence adapters when data shapes change.

## Notes
- Ensure secrets (API keys) are passed via `--dart-define` and not persisted with recipes.
- Verify offline behavior by disabling network and confirming recipe save/open flows work end-to-end.
