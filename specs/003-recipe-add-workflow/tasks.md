# Tasks: Recipe Add Workflow with Ingredients, Steps, and Images

**Input**: Design documents from `/specs/003-recipe-add-workflow/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Constitution requires coverage for critical flows (add/validate recipe, offline reopen, widget flows). Include tests below per story.
**Organization**: Tasks are grouped by user story for independent implementation and testing.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Ensure environment and tooling are ready.

- [X] T001 Confirm Flutter dependencies and codegen tooling available (`flutter pub get`, build_runner) in project root
- [X] T002 [P] Verify Hive adapters/codegen pipeline runs (`flutter pub run build_runner build --delete-conflicting-outputs`)
- [X] T003 [P] Ensure analysis/format hooks ready (e.g., `flutter analyze`, `dart format`) in project root

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core models, repository contracts, and validation shared by all stories. ⚠️ Complete before any user story work.

- [X] T004 Create domain entities (Recipe, Ingredient, CookingStep, RecipeImage) with validation in `lib/domain/entities/recipe_entities.dart`
- [X] T005 Define recipe repository interface including ingredient/step/image handling in `lib/domain/repositories/recipe_repository.dart`
- [X] T006 [P] Implement validation helpers (title, ingredient quantity >0, image limits) in `lib/domain/usecases/recipe_validation.dart`
- [X] T007 [P] Add Hive DTOs/adapters for recipe, ingredient, step, image references in `lib/data/models/recipe_dtos.dart`
- [X] T008 Implement Hive recipe repository with local image references and offline reopen support in `lib/data/repositories/local_recipe_repository.dart`
- [X] T009 [P] Add image file storage helper (save/check size/limit/delete) in `lib/data/services/image_storage_service.dart`
- [X] T010 Wire repository provider with Riverpod and async safety guards (`ref.mounted`) in `lib/presentation/providers/recipe_repository_provider.dart`
- [X] T011 Add unit tests for validation and repository save/reopen (including limits and permission-denied behavior mocked) in `test/unit/recipe_repository_test.dart`
- [ ] T032 Add sync-ready image metadata (fileName, size bytes, addedAt) to DTOs and schema tests in `lib/data/models/recipe_dtos.dart` and `test/unit/recipe_repository_test.dart`

**Checkpoint**: Foundation ready—repository + validation usable offline.

---

## Phase 3: User Story 1 - Add recipe with ingredients (Priority: P1) 🎯 MVP

**Goal**: Users can add a recipe with title and ingredients (names + quantities) and save offline.

**Independent Test**: Add ≥3 ingredients with quantities, save, restart app offline, reopen recipe with intact ingredients.

### Tests for User Story 1

- [X] T012 [P] [US1] Widget test: add-recipe form blocks save without title/ingredient; allows save with valid inputs in `test/widget/add_recipe_ingredients_test.dart`
- [X] T013 [P] [US1] Integration test: offline save/reopen with ingredients persists accurately in `test/integration/add_recipe_offline_test.dart`

### Implementation for User Story 1

- [X] T014 [US1] Build ingredient form components (list, add/remove/edit, quantity input validation) in `lib/presentation/widgets/ingredient_list.dart`
- [X] T015 [US1] Update add-recipe screen to require title + ≥1 ingredient before save, show validation messaging in `lib/presentation/screens/create_recipe_screen.dart`
- [X] T016 [US1] Implement add-recipe controller/notifier to manage draft, validation, and save call in `lib/presentation/providers/add_recipe_controller.dart`
- [X] T017 [US1] Add loading/error/success states and navigation back on save with snackbar confirmation in `lib/presentation/screens/create_recipe_screen.dart`

**Checkpoint**: US1 independently testable; recipe with ingredients saves offline.

---

## Phase 4: User Story 2 - Add cooking steps (Priority: P2)

**Goal**: Users can enter ordered cooking steps and preserve order on save/reopen.

**Independent Test**: Add ≥3 steps, reorder, save, restart offline, reopen with exact order.

### Tests for User Story 2

- [X] T018 [P] [US2] Widget test: add/reorder/delete steps preserves order on save in `test/widget/add_recipe_steps_test.dart`

### Implementation for User Story 2

- [X] T019 [US2] Build steps list UI with add/edit/delete/reorder support in `lib/presentation/widgets/steps_list.dart`
- [X] T020 [US2] Extend add-recipe controller to manage ordered steps and enforce contiguous positions in `lib/presentation/providers/add_recipe_controller.dart`
- [X] T021 [US2] Persist and reload ordered steps via repository, update mapper if needed in `lib/data/repositories/local_recipe_repository.dart`

**Checkpoint**: US2 independently testable; steps order round-trips offline.

---

## Phase 5: User Story 3 - Attach images locally (Priority: P3)

**Goal**: Users can attach images stored locally, view them offline; handle permission denial gracefully.

**Independent Test**: Attach ≥2 images, save, restart offline, images visible; permission denied shows message and allows save without images.

### Tests for User Story 3

- [X] T022 [P] [US3] Widget test: image attach flow shows previews and enforces 5-image cap in `test/widget/add_recipe_images_test.dart`
- [X] T023 [P] [US3] Integration test: offline reopen renders attached images from local paths in `test/integration/add_recipe_images_offline_test.dart`
- [ ] T033 [P] [US3] Widget test: reject images >5MB with warning and keep flow usable in `test/widget/add_recipe_images_test.dart`
- [X] T034 [P] [US3] Widget test: permission denied shows message within 2s and allows save without images in `test/widget/add_recipe_images_test.dart`

### Implementation for User Story 3

- [X] T024 [US3] Implement image picker integration with permission handling and size checks in `lib/presentation/providers/add_recipe_controller.dart`
- [X] T025 [US3] Add image preview grid with remove action and limit messaging in `lib/presentation/widgets/recipe_image_grid.dart`
- [X] T026 [US3] Persist image references and file copies through repository/service; enforce 5-image and 5MB-per-image caps in `lib/data/services/image_storage_service.dart`
- [X] T026a [US3] Persist sync-ready image metadata (fileName, size, addedAt) for future cloud sync in `lib/data/services/image_storage_service.dart`

**Checkpoint**: US3 independently testable; images persist offline; denial handled.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T027 [P] Update quickstart and docs with new flows and limits in `specs/003-recipe-add-workflow/quickstart.md`
- [X] T028 [P] Add edge-case tests (empty steps allowed, ingredient edits, permission denial path) in `test/widget/add_recipe_edge_cases_test.dart`
- [X] T029 [P] Run full test suite and fix lint/format issues in project root (`flutter analyze`, `flutter test`)
- [X] T030 Validate performance (no jank during image attach/save) and add notes to `specs/003-recipe-add-workflow/research.md`
- [X] T036 [P] Measure and log timing for permission-denied messaging (<2s) and over-cap warnings; record in `specs/003-recipe-add-workflow/research.md`
- [X] T031 Final code review checklist and ensure codegen outputs committed (e.g., adapters) in project root

---

## Dependencies & Execution Order

- Phase dependencies: Setup → Foundational (blocks all stories) → US1 → US2 → US3 → Polish.
- Within US1/US2/US3: tests can be written in parallel with UI work but should run/fail before feature code completion.
- Parallel opportunities: Tasks marked [P] are parallel-safe (different files, low coupling).

---

## Parallel Execution Examples

- Run widget/integration tests in parallel per story (e.g., T012 + T013).
- Develop ingredient UI (T014) in parallel with controller logic (T016) once validation helpers (T006) exist.
- Image UI (T025) can proceed in parallel with storage service hardening (T026) after foundational repository (T008) is ready.

---

## Implementation Strategy

### MVP First
- Complete Phases 1–2, then US1. Ship MVP with ingredients-only add/save offline.

### Incremental Delivery
- After MVP, deliver US2 (steps) independently, then US3 (images). Each story remains testable and shippable on its own.
