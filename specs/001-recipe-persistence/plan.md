# Implementation Plan: Persistent Local Recipe Storage

**Branch**: `001-recipe-persistence` | **Date**: 2025-12-02 | **Spec**: specs/001-recipe-persistence/spec.md
**Input**: Ensure user-generated and saved recipes are stored persistently and efficiently using a local database solution (e.g., Hive or SQLite via Drift). Refer to file persistence_spec.md

**Note**: This template is filled in by the `/speckit.plan` command. Constitution guardrails live in `.specify/memory/constitution.md`; use them as gates and approvals.

## Summary

Persist all user-created and AI-generated recipes locally for offline availability, with reliable save/edit/delete flows, schema evolution safety, and a clear back-to-home control on detail screens. Use the existing Flutter app stack (Dart, Riverpod, GoRouter) with a local database (Hive baseline; evaluate Drift only if Hive gaps emerge) to store recipe entities and keep tests and codegen current.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart (Flutter stable)  
**Primary Dependencies**: Flutter, Riverpod (with annotations), GoRouter, Freezed/codegen tools  
**Storage**: Local database (Hive baseline; Drift only if blockers identified)  
**Testing**: `flutter test` (unit + widget), contract/parsing tests for persistence adapters  
**Target Platform**: Mobile (iOS, Android)  
**Project Type**: Mobile app  
**Performance Goals**: 60 fps UI; save/edit/delete completes <2s on mid-range devices  
**Constraints**: Offline-first; no hardcoded secrets; schema evolution without data loss  
**Scale/Scope**: Single app codebase with domain/data/presentation layers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Architecture boundaries: presentation (Flutter + Riverpod + GoRouter) depends only on domain contracts; domain stays pure Dart; integrations live in data layer.
- Data handling and AI scope: ingredient-led Vietnamese recipes, structured responses, secrets supplied via env/defines, no hardcoded keys.
- Offline resilience: My Recipes stored locally (Hive or successor) and flows degrade gracefully when network/AI/camera is unavailable.
- Quality gates: planned tests for domain use cases, widget coverage for recipe list/detail/scan, lint/format/codegen steps listed.
- UX/performance: loading skeletons, error/retry states, dark mode/text scaling, and animation/performance expectations (smooth/60fps target).

*Status: PASS — plan keeps clean layering, offline-first storage, required tests, and UX/back navigation control.*

## Project Structure

### Documentation (this feature)

```text
specs/001-recipe-persistence/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
lib/
├── data/                 # repositories, adapters (Hive)
├── domain/               # entities, use cases (pure Dart)
├── presentation/         # Flutter UI, Riverpod providers, routing
└── main.dart

test/
├── widget/               # recipe list/detail, navigation/back control
├── domain/               # use-case tests
└── data/                 # storage adapter/contract tests

specs/001-recipe-persistence/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

**Structure Decision**: Mobile Flutter app with Clean Architecture layering (domain/data/presentation) and tests grouped by layer and UI flow.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | — | — |
