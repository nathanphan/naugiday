# Implementation Plan: Scan UX States

**Branch**: `007-scan-ux` | **Date**: 2025-12-30 | **Spec**: /Users/god/Work/NauGiDay/specs/007-scan-ux/spec.md
**Input**: Feature specification from `/Users/god/Work/NauGiDay/specs/007-scan-ux/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Deliver the full scan UX for iOS across five states (normal, initializing, camera unavailable, permission denied, disabled), adding gallery picker support, stronger error/offline handling, and minimal analytics. The plan uses existing camera and image picker integrations, introduces offline queue persistence in Hive, and aligns UI to the design assets while meeting accessibility and performance constraints.

## Technical Context

**Language/Version**: Dart 3.10.1, Flutter stable  
**Primary Dependencies**: Flutter Material 3, Riverpod (annotations/codegen), GoRouter, camera, image_picker, Hive, path_provider, freezed/json_serializable  
**Storage**: Hive boxes + file storage in app documents/cache  
**Testing**: flutter_test (widget), integration_test (flows), golden as needed  
**Target Platform**: iOS 15+ (iOS-only phase)  
**Project Type**: Mobile app  
**Performance Goals**: 60fps target (<=16ms frame budget), scan screen interactive <=2s (p95)  
**Constraints**: Offline-first behavior, Material 3 UI, no hardcoded colors, minimal analytics without PII, feature-flag kill switch, no backend changes  
**Scale/Scope**: Single scan flow covering 5 UI states with offline queue

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

## Project Structure

### Documentation (this feature)

```text
/Users/god/Work/NauGiDay/specs/007-scan-ux/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
/Users/god/Work/NauGiDay/lib/
├── core/
│   ├── constants/
│   └── debug/
├── data/
│   ├── local/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── router/
    ├── screens/
    │   └── scan_screen.dart
    └── widgets/
        ├── camera_controls_overlay.dart
        ├── scan_preview_sheet.dart
        └── skeletons.dart

/Users/god/Work/NauGiDay/test/
└── widget/
    ├── scan_camera_unavailable_test.dart
    └── scan_label_propagation_test.dart
```

**Structure Decision**: Continue with the existing Flutter monorepo layout under `lib/` (core, data, domain, presentation) and `test/` for widget tests. All scan UX updates will live under `presentation/`, while offline queue and analytics wiring stays under `domain/` and `data/`.

## Constitution Check (Post-Design)

- Architecture boundaries preserved with new scan queue repositories in `domain/` and `data/`.
- Offline-first flow covered via local queue and file persistence.
- UX/accessibility addressed through state-specific screens, semantic labels, and tap targets.
- Quality gates planned with widget and integration tests per user story.
- Telemetry remains minimal and PII-safe.
- App Store compliance maintained with required purpose strings for camera/photos.

## Complexity Tracking

> No violations.
