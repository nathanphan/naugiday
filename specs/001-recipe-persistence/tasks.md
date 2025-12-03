---

description: "Task list template for feature implementation"
---

# Tasks: Persistent Local Recipe Storage

**Input**: Design documents from `/specs/001-recipe-persistence/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests for critical flows (domain/use-case coverage and widget tests for recipe list/detail/scan) are REQUIRED by the constitution; add any additional tests requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.
**Constitution alignment**: Include tasks for offline/local persistence readiness, AI data handling/prompt validation, and UX/performance polish (loading/error states, dark mode/text scaling). Guard async state updates to avoid disposed-provider writes.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `lib/`, `test/` at repository root
- Paths below reference the existing Clean Architecture layout

---

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 Verify Flutter toolchain and run `flutter pub get` in repo root
- [X] T002 Ensure codegen dependencies are present in `pubspec.yaml` (freezed_annotation, build_runner, riverpod_generator, freezed)
- [X] T003 Run baseline codegen `dart run build_runner build --delete-conflicting-outputs` to sync generated files
- [X] T004 Create feature docs folder structure if missing in `specs/001-recipe-persistence/` (already present)

---

## Phase 2: Foundational (Blocking Prerequisites)

- [X] T005 Define Hive type adapters for Recipe aggregate in `lib/data/adapters/recipe_adapter.dart`
- [X] T006 Add Hive initialization and box open for recipes in `lib/data/local/hive_setup.dart`
- [X] T007 Create domain repository interface for recipes in `lib/domain/repositories/recipe_repository.dart`
- [X] T008 Implement local Hive repository skeleton (save/get/list/delete) in `lib/data/repositories/local_recipe_repository.dart`
- [X] T009 Wire repository provider/DI in `lib/data/repositories/local_recipe_repository.dart`
- [X] T010 [P] Add contract/parsing tests for adapter round-trip in `test/data/recipe_adapter_test.dart`
- [X] T011 [P] Add use-case tests for save/list/delete in `test/domain/recipe_repository_test.dart`
- [X] T034 Migrate legacy string-backed Hive entries to RecipeDto on open in `lib/data/repositories/local_recipe_repository.dart`

---

## Phase 3: User Story 1 - Save and reopen recipes offline (Priority: P1) 🎯 MVP

**Goal**: Users can save recipes and reopen them offline with full details.

**Independent Test**: Create a recipe, close the app, disable connectivity, reopen and access the saved recipe with full details, and navigate back to home via visible control.

### Implementation for User Story 1

- [X] T012 [US1] Implement use case for save recipe with timestamps in `lib/domain/usecases/save_recipe.dart`
- [X] T013 [US1] Implement use case for list recipes offline in `lib/domain/usecases/list_recipes.dart`
- [X] T014 [US1] Add persistence workflow in `lib/presentation/providers/recipe_controller.dart` to call save/list use cases
- [X] T015 [US1] Add recipe save form/back-home control in `lib/presentation/screens/recipe_edit_screen.dart`
- [X] T016 [US1] Add offline-aware recipe list/detail UI in `lib/presentation/screens/recipe_list_screen.dart` and `lib/presentation/screens/recipe_detail_screen.dart`

### Tests for User Story 1

- [X] T017 [P] [US1] Widget test: save + reopen offline flow in `test/widget/recipe_save_offline_test.dart`
- [X] T018 [P] [US1] Provider/unit test: controller uses repository correctly in `test/domain/recipe_controller_test.dart`

---

## Phase 4: User Story 2 - Manage saved recipes (Priority: P2)

**Goal**: Users can edit or delete saved recipes with durable changes across restarts.

**Independent Test**: Edit a saved recipe title and delete another; restart the app and confirm edits persist and deleted items stay removed.

### Implementation for User Story 2

- [X] T019 [US2] Implement update recipe use case in `lib/domain/usecases/update_recipe.dart`
- [X] T020 [US2] Extend repository with update support in `lib/data/repositories/local_recipe_repository.dart`
- [X] T021 [US2] Add edit flow UI (reuse form) in `lib/presentation/screens/create_recipe_screen.dart`
- [X] T022 [US2] Add delete action with confirmation in `lib/presentation/screens/recipe_detail_screen.dart`

### Tests for User Story 2

- [X] T023 [P] [US2] Use-case test for update and delete persistence in `test/domain/recipe_repository_test.dart`
- [X] T024 [P] [US2] Widget test: edit/delete durability across restart in `test/widget/recipe_edit_delete_test.dart`

---

## Phase 5: User Story 3 - Safeguard data integrity (Priority: P3)

**Goal**: Protect saved recipes from corruption and surface recovery guidance.

**Independent Test**: Simulate interrupted write; app reports issue, preserves existing recipes, and can save again after recovery.

### Implementation for User Story 3

- [X] T025 [US3] Add guarded write/read with validation in `lib/data/repositories/local_recipe_repository.dart`
- [X] T026 [US3] Implement error states and retry messaging in `lib/presentation/providers/recipe_controller.dart`
- [X] T027 [US3] Add user-facing recovery UI in `lib/presentation/screens/my_recipes_screen.dart`

### Tests for User Story 3

- [X] T028 [P] [US3] Data test: simulate storage failure and recovery in `test/data/recipe_recovery_test.dart`
- [X] T029 [P] [US3] Widget test: error/retry UX for failed save in `test/widget/recipe_error_retry_test.dart`

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T030 Add loading skeletons/error states/back navigation UX polish in `lib/presentation/screens/my_recipes_screen.dart` and `lib/presentation/screens/recipe_detail_screen.dart`
- [X] T031 Run full `flutter test` and fix any regressions
- [X] T032 Update docs with persistence instructions in `specs/001-recipe-persistence/quickstart.md`
- [X] T033 Ensure secrets are excluded and env/define wiring documented in `README.md`
- [X] T034 Check Home screen make the text in  meal selector to be fit inside of its box, not to drop.

---

## Dependencies & Execution Order

- Setup (Phase 1) → Foundational (Phase 2) → User Story 1 (Phase 3) → User Story 2 (Phase 4) → User Story 3 (Phase 5) → Polish (Phase 6)
- User Story dependencies: US1 is MVP baseline; US2 builds on repository/edit/delete; US3 builds on stable persistence from US1/US2.

## Parallel Examples

- Adapter and use-case tests (T010, T011) can run in parallel.
- Widget and domain tests per story (T017/T018, T023/T024, T028/T029) can run in parallel once corresponding implementations exist.
- UI polish tasks (T030) can run after core story UIs land.

## Implementation Strategy

- MVP first: Complete Phases 1–3 to deliver offline save/reopen with back navigation.
- Incremental delivery: Add edit/delete (Phase 4), then integrity/recovery (Phase 5), then polish (Phase 6).
