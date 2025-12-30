# Implementation Plan: Add Ingredient Photos

**Branch**: `006-add-ingredient-photos` | **Date**: 2025-12-30 | **Spec**: /Users/god/Work/NauGiDay/specs/006-add-ingredient-photos/spec.md
**Input**: Feature specification from `/Users/god/Work/NauGiDay/specs/006-add-ingredient-photos/spec.md`

## Summary

Add photo attachment for ingredients across add and edit flows, including camera/gallery selection, a 3-photo limit with thumbnail management, and full-size viewing. The implementation will follow the existing clean architecture (domain/data/presentation), use Riverpod for state, GoRouter for navigation, Hive for local metadata, and file storage in the app documents directory for offline persistence.

## Technical Context

**Language/Version**: Dart 3.10.1 (Flutter stable)
**Primary Dependencies**: Flutter Material 3, flutter_riverpod/riverpod_annotation, go_router, hive/hive_flutter, freezed/json_serializable, path_provider, camera, image_picker (new)
**Storage**: Hive boxes for ingredient metadata; local file system for photo files
**Testing**: flutter_test (unit/widget) and existing integration test setup
**Target Platform**: iOS (project deployment target)
**Project Type**: mobile app
**Performance Goals**: 60fps interactions (<=16ms frame budget); photo selection and full-size viewing <2s on typical devices
**Constraints**: offline-first; max 3 photos per ingredient; theme-based colors only; accessible tap targets and VoiceOver labels; minimal analytics without PII
**Scale/Scope**: single-user local pantry; up to ~500 ingredients; 0-3 photos per ingredient

## Testing Strategy

- Add domain/use-case tests for photo validation, limit enforcement, and persistence metadata.
- Add widget tests for add/edit photo flows, thumbnail deletion, and full-size viewer.
- Cover permission-denied and missing-file error states.

## Migration & Compatibility

- Extend ingredient storage schema to include photo references; add Hive adapter migration steps.
- Add backward/forward compatibility tests for ingredient photo fields.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Architecture boundaries: presentation depends on domain contracts; domain is
  pure Dart; integrations live in data layer.
- Offline-first persistence: core flows work offline; schema changes avoid data
  loss; graceful degradation when network/AI/camera is unavailable.
- UX/performance/accessibility: loading/empty/error states, dark mode/text
  scaling, tap targets/VoiceOver, 60fps target (<=16ms frame budget).
- Quality gates: critical flows have automated tests; async state updates are
  guarded; codegen/lint/format steps accounted for.
- Data handling & safety: secrets via env/`--dart-define`; minimal analytics and
  PII-safe logging; feature flags/kill-switches in place.
- Production readiness: App Store purpose strings/privacy details captured,
  crash reporting enabled, AI via server proxy only, CI checks defined.

**Result (pre-design)**: Pass
**Result (post-design)**: Pass

## Project Structure

### Documentation (this feature)

```text
/Users/god/Work/NauGiDay/specs/006-add-ingredient-photos/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
/Users/god/Work/NauGiDay/lib/
├── core/
├── data/
├── domain/
├── presentation/
└── main.dart

/Users/god/Work/NauGiDay/test/
├── data/
├── domain/
├── integration/
├── presentation/
├── unit/
├── widget/
└── widget_test.dart
```

**Structure Decision**: Single Flutter app using the existing core/data/domain/presentation layers and current test layout.
