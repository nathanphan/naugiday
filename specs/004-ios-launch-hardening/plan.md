# Implementation Plan: Day-1 Launch Hardening (iOS)

**Branch**: `004-ios-launch-hardening` | **Date**: 2025-12-28 | **Spec**: `specs/004-ios-launch-hardening/spec.md`
**Input**: Feature specification from `/specs/004-ios-launch-hardening/spec.md`

**Note**: This plan adheres to `.specify/memory/constitution.md` guardrails.

## Summary

Ship day-1 iOS launch hardening by completing App Store compliance assets
(purpose strings, privacy policy URL, App Privacy details), enabling crash
reporting, adding minimal analytics (screen_view + three CTAs), enforcing PII-safe
logging with default-off diagnostics, and implementing remote kill switches for
AI and image features. Validate accessibility (VoiceOver labels, tap targets),
apply a 60fps/16ms performance budget checklist, and deliver a release checklist
with a rollback plan prioritizing remote disablement of AI and images.

## Technical Context

**Language/Version**: Dart 3.x / Flutter (stable toolchain).  
**Primary Dependencies**: Flutter Material 3, Riverpod (annotations/codegen),
GoRouter, Hive; minimal telemetry and config endpoints provided by the existing
server proxy (no client secrets).  
**Storage**: Local app storage for release checklist artifacts and feature flag
cache; remote config fetched at runtime.  
**Testing**: `flutter test` (unit/widget), manual QA checklist for release flows,
accessibility checks with VoiceOver, performance profiling, and CI checks for
tests/lint/format/release build.  
**Target Platform**: iOS-only (first submission).  
**Project Type**: Mobile app with layered clean architecture
(presentation/domain/data).  
**Performance Goals**: 60fps target with 95% of frames ≤16ms in primary flows.  
**Constraints**: Offline-first core flows; PII-safe logging; analytics limited to
screen_view + three CTAs; remote kill switches for AI/images; App Store privacy
and purpose strings complete; AI calls must go via server proxy; CI checks must
pass before release.  
**Scale/Scope**: Single-app release; low event volume (screen + three CTAs);
feature flags limited to AI and image flows.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Architecture boundaries: presentation depends on domain contracts; domain is
  pure Dart; integrations live in data layer.
- Offline-first persistence: core flows work offline; schema changes avoid data
  loss; graceful degradation when network/AI/camera is unavailable.
- UX/performance/accessibility: loading/empty/error states, dark mode/text
  scaling, tap targets/VoiceOver, 60fps target (≤16ms frame budget).
- Quality gates: critical flows have automated tests; async state updates are
  guarded; codegen/lint/format steps accounted for.
- Data handling & safety: secrets via env/`--dart-define`; minimal analytics and
  PII-safe logging; feature flags/kill-switches in place.
- Production readiness: App Store purpose strings/privacy details captured,
  crash reporting enabled, AI via server proxy only, CI checks defined.

## Project Structure

### Documentation (this feature)

```text
specs/004-ios-launch-hardening/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── data/
│   ├── models/           # telemetry, feature flag cache, release checklist
│   ├── repositories/     # config/telemetry repositories
│   └── services/         # crash reporting, logging, analytics adapters
├── domain/
│   ├── entities/         # FeatureFlag, TelemetryEvent, ReleaseChecklistItem
│   └── usecases/         # fetch flags, emit events, validate checklist
├── presentation/
│   ├── providers/        # Riverpod controllers for flags + telemetry
│   ├── screens/          # release checklist, settings/diagnostics
│   └── widgets/          # accessibility helpers, status banners
```

test/
├── unit/                 # entity validation, flag parsing, logging guards
├── widget/               # accessibility labels, kill switch UI states
└── integration/          # remote flag toggle, offline fallback behaviors

**Structure Decision**: Mobile Flutter app with existing layered clean
architecture; implement hardening changes across `lib/presentation`,
`lib/domain`, and `lib/data`, plus tests under `test/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
