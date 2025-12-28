<!--
Sync Impact Report
Version change: 1.0.0 -> 1.1.0
Modified principles:
- III. UX Performance & Accessibility -> III. UX Performance & Accessibility (expanded: tap targets,
  VoiceOver, perf budgets)
- V. Data Handling, Secrets, and Debug Controls -> V. Data Handling, Telemetry, and Control
Added sections:
- VI. Production Readiness & App Store Compliance
Removed sections: None
Templates requiring updates:
- ✅ .specify/templates/plan-template.md
- ✅ .specify/templates/spec-template.md
- ✅ .specify/templates/tasks-template.md
- ⚠ pending: .specify/templates/commands/ (directory not found)
- ✅ README.md
Follow-up TODOs:
- TODO(RATIFICATION_DATE): original adoption date not recorded.
-->
# NauGiDay Constitution

## Core Principles

### I. Clean Architecture Boundaries
Presentation (Flutter UI + Riverpod + GoRouter) MUST depend only on domain
contracts. The domain layer MUST remain pure Dart with no Flutter, storage, or
platform dependencies. All integrations (Hive, image picker, AI stubs) MUST live
in the data layer behind repository interfaces. This enforces testability and
keeps feature scope contained.

### II. Offline-First Persistence
Core user flows (save, edit, reopen recipes; attached images) MUST work without
network connectivity. Local storage is the source of truth in this phase (Hive
or successor) and schema evolution MUST not lose data. When camera, network, or
AI are unavailable, the UI MUST degrade gracefully with recovery guidance. This
protects user trust and app reliability.

### III. UX Performance & Accessibility
UI work MUST preserve smooth 60fps interactions with a 16ms frame budget target.
Every screen MUST include loading, empty, and error states, and MUST support
dark mode and text scaling. Tap targets MUST meet iOS accessibility sizing and
VoiceOver MUST expose actionable controls with meaningful labels. Animations and
shimmer effects MUST use Flutter SDK primitives and be profiled when they could
affect performance. This keeps the experience polished and inclusive.

### IV. Quality Gates & Async Safety
Critical flows MUST have automated tests (domain/use-case and widget or
integration coverage for each user story). Data migrations MUST include forward
compatibility tests. Async state updates MUST be guarded (e.g., `ref.mounted`)
to avoid disposed-provider writes. This prevents regressions and runtime
crashes.

### V. Data Handling, Telemetry, and Control
Recipe data MUST stay local and ingredient-led (Vietnamese recipes scope) with
structured AI responses when used. Secrets MUST be provided via `--dart-define`
or `.env` and MUST never be hardcoded or stored in recipe data. Analytics MUST
be minimal, opt-in where required by policy, and logging MUST avoid PII. Feature
flags and kill-switches MUST exist for critical flows and be remote-configurable
without client secrets. This keeps data safe, observable, and controllable.

### VI. Production Readiness & App Store Compliance
The iOS build MUST include required App Store privacy details, purpose strings,
and review-ready compliance notes. Crash reporting MUST be enabled with
PII-safe metadata. All AI calls MUST go through a server proxy; the client MUST
never ship provider keys. CI MUST run core checks (tests, lint, formatting, and
build where applicable) before releases. This ensures day-1 production readiness.

## Product & Platform Constraints

- iOS-only distribution for this phase; Android/Web builds are out of scope.
- Flutter stable (Dart 3.x) with Material 3.
- State management via Riverpod (annotations + codegen); navigation via GoRouter.
- Persistence via Hive boxes; image files stored in app documents/cache with
  recipe-bound references.
- Image selection via `image_picker` or platform picker; no new backend
  dependencies in this phase.
- Shimmer/animations must use Flutter SDK (no new animation packages).
- App Store purpose strings and privacy details must be kept current for any
  capability (camera, photos, local storage, network).

## Development Workflow & Quality Gates

- Specs, plans, and tasks MUST include a Constitution Check aligned to the core
  principles before implementation starts.
- Schema or adapter changes MUST document migration steps and include tests for
  backward/forward compatibility.
- Performance-sensitive UI changes MUST include profiling notes (target p95
  frame time ≤16ms) in research or quickstart docs.
- Codegen (`build_runner`), lint, and format steps MUST be listed in plans and
  kept passing for feature completion.
- CI MUST include tests, lint, formatting, and a release-mode iOS build check
  for App Store compliance.

## Governance

- This constitution supersedes local conventions and feature specs when in
  conflict.
- Amendments require updating this file, bumping the version per semantic
  versioning, and recording dates.
- Compliance must be verified in feature planning (plan/spec/tasks). Exceptions
  require explicit justification in plan "Complexity Tracking."
- Runtime guidance lives in `README.md` and the active feature specs in `specs/`.

**Version**: 1.1.0 | **Ratified**: TODO(RATIFICATION_DATE): original adoption date not recorded. | **Last Amended**: 2025-12-28
