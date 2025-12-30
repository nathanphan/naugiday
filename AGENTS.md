# NauGiDay Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-12-02

## Active Technologies
- Dart (Flutter stable) + Flutter (Material 3), Riverpod, GoRouter; add shimmer/animations using Flutter SDK (no new backend deps) (002-ui-ux-improvements)
- N/A (UI/UX only; reuse existing Hive/local state) (002-ui-ux-improvements)
- Dart 3.x / Flutter (current project toolchain) + Riverpod (controllers/providers), GoRouter (navigation), Hive (local persistence), image_picker or platform picker for local photos, Freezed/JsonSerializable/Riverpod codegen (existing). (003-recipe-add-workflow)
- Hive boxes for recipes; image files stored in app documents/cache with recipe-bound references; no cloud in this phase. (003-recipe-add-workflow)
- Dart 3.x / Flutter (stable toolchain). + Flutter Material 3, Riverpod (annotations/codegen), (004-ios-launch-hardening)
- Local app storage for release checklist artifacts and feature flag (004-ios-launch-hardening)
- Dart 3.10.1 (Flutter stable) + Flutter Material 3, flutter_riverpod/riverpod_annotation, go_router, hive/hive_flutter, freezed/json_serializable, uuid, equatable (005-ingredient-management)
- Hive boxes (local device storage) (005-ingredient-management)

- Dart (Flutter stable) + Flutter, Riverpod (with annotations), GoRouter, Freezed/codegen tools (001-recipe-persistence)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Dart (Flutter stable)

## Code Style

Dart (Flutter stable): Follow standard conventions

## Recent Changes
- 005-ingredient-management: Added Dart 3.10.1 (Flutter stable) + Flutter Material 3, flutter_riverpod/riverpod_annotation, go_router, hive/hive_flutter, freezed/json_serializable, uuid, equatable
- 004-ios-launch-hardening: Added Dart 3.x / Flutter (stable toolchain). + Flutter Material 3, Riverpod (annotations/codegen),
- 003-recipe-add-workflow: Added Dart 3.x / Flutter (current project toolchain) + Riverpod (controllers/providers), GoRouter (navigation), Hive (local persistence), image_picker or platform picker for local photos, Freezed/JsonSerializable/Riverpod codegen (existing).


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
