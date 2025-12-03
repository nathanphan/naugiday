# Implementation Plan: UI/UX Improvements

**Branch**: `002-ui-ux-improvements` | **Date**: 2025-12-03 | **Spec**: specs/002-ui-ux-improvements/spec.md
**Input**: Feature specification from `/specs/002-ui-ux-improvements/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. Constitution guardrails live in `.specify/memory/constitution.md`; use them as gates and approvals.

## Summary

Polish core UI/UX flows with skeleton/shimmer loading, smooth hero/entrance animations, clear illustrated error/empty states with recovery CTAs, richer interactions (ingredient labeling, swipe/undo, favorite/share), and debug toggles to force loading/error/empty/camera/storage states without impacting production. Stay within the existing Flutter + Riverpod + GoRouter stack and reuse assets (`AppAssets.foodPlaceholder`, `AppAssets.emptyState`) and current presentation components.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart (Flutter stable)  
**Primary Dependencies**: Flutter (Material 3), Riverpod, GoRouter; add shimmer/animations using Flutter SDK (no new backend deps)  
**Storage**: N/A (UI/UX only; reuse existing Hive/local state)  
**Testing**: `flutter test` (widget + unit), consider golden tests for skeletons (optional)  
**Target Platform**: Mobile (iOS/Android)  
**Project Type**: Mobile app with layered architecture (presentation/domain/data)  
**Performance Goals**: Smooth motion/hero/entrance at ≤16ms frame budget (60 fps target)  
**Constraints**: Must honor offline/read-only flows; no production impact from debug toggles; maintain dark mode/text scaling and contrast  
**Scale/Scope**: Existing app screens (Home, Scan, Suggestions, Detail, My Recipes); no new backend endpoints

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Architecture boundaries: presentation (Flutter + Riverpod + GoRouter) depends only on domain contracts; domain stays pure Dart; integrations live in data layer. **Status: PASS** (UI polish only).
- Data handling and AI scope: ingredient-led Vietnamese recipes, structured responses, secrets via env/defines, no hardcoded keys. **Status: PASS** (no new data handling).
- Offline resilience: My Recipes stored locally (Hive or successor) and flows degrade gracefully when network/AI/camera is unavailable. **Status: PASS** (ensure toggles don’t break offline behavior).
- Quality gates: planned tests for critical flows (widget coverage for list/detail/scan), lint/format/codegen. **Status: PASS** (add widget tests for states/animations where feasible).
- UX/performance: loading skeletons, error/retry states, dark mode/text scaling, smooth 60fps. **Status: PASS** (explicit in requirements).

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
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
├── presentation/
│   ├── screens/              # Home, Scan, Suggestions, Detail, MyRecipes
│   ├── widgets/              # Cards, chips, overlays
│   ├── router/               # GoRouter config
│   └── theme/                # AppTheme tokens
├── domain/                   # Entities/use cases (unchanged)
└── data/                     # Existing repositories (unchanged)

test/
├── widget/                   # UI states, animations, interactions
├── domain/                   # Existing domain tests
└── data/                     # Existing data tests

specs/002-ui-ux-improvements/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

**Structure Decision**: Single Flutter mobile app using existing clean architecture folders; focus on presentation layer with debug toggles guarded from production.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
