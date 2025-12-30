# Implementation Plan: Ingredient Management

**Branch**: `005-ingredient-management` | **Date**: 2025-12-29 | **Spec**: /Users/god/Work/NauGiDay/specs/005-ingredient-management/spec.md
**Input**: Feature specification from `/Users/god/Work/NauGiDay/specs/005-ingredient-management/spec.md`

## Summary

Deliver a cohesive ingredient management flow (list/detail/add/edit/bulk manage) with offline local persistence, validation, confirmations, and minimal analytics events. The implementation will follow the existing clean architecture (domain/data/presentation), use Riverpod for state, GoRouter for navigation, and Hive for local storage.

## Technical Context

**Language/Version**: Dart 3.10.1 (Flutter stable)
**Primary Dependencies**: Flutter Material 3, flutter_riverpod/riverpod_annotation, go_router, hive/hive_flutter, freezed/json_serializable, uuid, equatable
**Storage**: Hive boxes (local device storage)
**Testing**: flutter_test (unit/widget) and existing integration test setup
**Target Platform**: iOS (project deployment target)
**Project Type**: mobile app
**Performance Goals**: 60fps interactions (<=16ms frame budget); list loads <2s with 500 ingredients
**Constraints**: offline-first; theme-based colors only; accessible tap targets and VoiceOver labels; minimal analytics without PII
**Scale/Scope**: single-user local pantry; up to ~500 ingredients; 5 primary screens

## Testing Strategy

- Add domain/use-case tests and widget or integration tests for each user story.
- Cover list filtering, detail actions, add/edit validation, and bulk updates.

## Migration & Compatibility

- Document Hive adapter migration steps for ingredient data.
- Add backward/forward compatibility tests for ingredient box reads.

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
/Users/god/Work/NauGiDay/specs/005-ingredient-management/
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
