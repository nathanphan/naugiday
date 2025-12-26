# Implementation Plan: Recipe Add Workflow with Ingredients, Steps, and Images

**Branch**: `003-recipe-add-workflow` | **Date**: 2025-12-04 | **Spec**: `specs/003-recipe-add-workflow/spec.md`
**Input**: Feature specification from `/specs/003-recipe-add-workflow/spec.md`

**Note**: This plan adheres to `.specify/memory/constitution.md` guardrails.

## Summary

Deliver an add-recipe workflow that captures title, ingredients with quantities, ordered steps, and locally stored images. Persist all recipe data offline (Hive-backed) with validation (title + ≥1 ingredient; quantities must be valid) and permission-safe image handling. Prepare data structures for later cloud sync without implementing remote upload this phase.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart 3.x / Flutter (current project toolchain)  
**Primary Dependencies**: Riverpod (controllers/providers), GoRouter (navigation), Hive (local persistence), image_picker or platform picker for local photos, Freezed/JsonSerializable/Riverpod codegen (existing).  
**Storage**: Hive boxes for recipes; image files stored in app documents/cache with recipe-bound references; no cloud in this phase.  
**Testing**: `flutter test` with widget tests for add-recipe flows; unit tests for validation and persistence; golden tests optional if UI diffs needed.  
**Target Platform**: Mobile (iOS/Android) with offline support.  
**Project Type**: Mobile app with layered clean architecture (presentation/domain/data).  
**Performance Goals**: Maintain 60fps UI; add/save actions complete within 1s perceived latency; offline reopen latency <500ms for typical recipe; image attach feedback <2s including permission prompt.  
**Constraints**: Offline-first; guard disposed providers on async work; enforce validation (title + ≥1 ingredient, positive quantities); cap images to 5 per recipe and <=5MB each, warning on breach; avoid blocking UI thread during file IO.  
**Scale/Scope**: Personal recipe app scale; recipe count in thousands, per-recipe payload under ~10MB including images.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Architecture boundaries: Keep presentation (Flutter UI + Riverpod + GoRouter) depending on domain contracts; persistence/image IO isolated in data layer. No Flutter/IO leakage into domain.
- Data handling and AI scope: Local-only recipes; no remote calls or AI in this phase. Secrets remain in env/defines; none should be hardcoded.
- Offline resilience: All recipe content (ingredients, steps, image references) must persist locally via Hive; flows usable offline with graceful permission denials for images.
- Quality gates: Add unit/widget tests for add-recipe validation and offline reopen; ensure codegen/lint/format run; guard async updates with `ref.mounted`/dispose-safe patterns.
- UX/performance: Maintain smooth input/reorder/attach flows, support dark mode/text scaling, show clear validation/errors, and avoid UI thread blocking on file IO.

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
```text
lib/
├── data/
│   ├── models/           # Hive DTOs / adapters
│   ├── repositories/     # recipe repository handling persistence + image refs
│   └── services/         # file/image helpers (local storage)
├── domain/
│   ├── entities/         # Recipe, Ingredient, CookingStep, RecipeImage
│   └── usecases/         # add/update recipe, validate recipe
├── presentation/
│   ├── providers/        # Riverpod notifiers/controllers for add-recipe
│   ├── screens/          # add-recipe UI
│   └── widgets/          # ingredient list, step list, image picker UI
```

tests/
├── unit/                 # domain validations, repository logic
├── widget/               # add-recipe screen, image attach, validation flows
└── integration/          # offline save/reopen, image persistence path

**Structure Decision**: Mobile Flutter app with layered clean architecture; work will extend existing `lib/presentation`, `lib/domain`, and `lib/data` folders plus corresponding tests under `test/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
