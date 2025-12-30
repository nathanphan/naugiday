---

description: "Task list for ingredient management implementation"
---

# Tasks: Ingredient Management

**Input**: Design documents from `/Users/god/Work/NauGiDay/specs/005-ingredient-management/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Tests are required by the constitution; add domain/use-case and widget or integration tests per user story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.
**Constitution alignment**: Tasks include offline resilience, loading/error/empty states, performance/accessibility, minimal analytics, feature flags/kill-switches, and guarded async state updates where relevant.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Mobile app**: `lib/` and `test/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Shared configuration and feature gating

- [x] T001 Create ingredient management constants (box names, default categories) in `lib/core/constants/ingredient_constants.dart`
- [x] T002 [P] Add ingredient feature flag to data model and repository in `lib/data/models/launch_hardening_models.dart`, `lib/data/repositories/feature_flag_repository.dart`
- [x] T003 [P] Expose ingredientsEnabled in feature flag state/provider in `lib/presentation/providers/feature_flag_provider.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain/data foundations required by all ingredient flows

- [x] T004 Define pantry ingredient entity and inventory/freshness enums in `lib/domain/entities/pantry_ingredient.dart`
- [x] T005 [P] Define ingredient category entity in `lib/domain/entities/ingredient_category.dart`
- [x] T006 Add ingredient storage exception in `lib/domain/errors/ingredient_storage_exception.dart`
- [x] T007 [P] Add pantry ingredient DTO in `lib/data/dtos/pantry_ingredient_dto.dart`
- [x] T008 [P] Add ingredient category DTO in `lib/data/dtos/ingredient_category_dto.dart`
- [x] T009 [P] Add Hive adapters for pantry ingredients/categories in `lib/data/adapters/pantry_ingredient_adapter.dart`
- [x] T010 Update Hive setup to register adapters and open boxes in `lib/data/local/hive_setup.dart`
- [x] T011 Define ingredient repository contract in `lib/domain/repositories/ingredient_repository.dart`
- [x] T012 Implement local ingredient repository with Hive, validation, and recovery in `lib/data/repositories/local_ingredient_repository.dart`
- [x] T013 [P] Add list/get/bulk use cases in `lib/domain/usecases/list_ingredients.dart`, `lib/domain/usecases/get_ingredient.dart`, `lib/domain/usecases/bulk_update_ingredients.dart`
- [x] T014 [P] Add save/update/delete/validate/category use cases in `lib/domain/usecases/save_ingredient.dart`, `lib/domain/usecases/update_ingredient.dart`, `lib/domain/usecases/delete_ingredient.dart`, `lib/domain/usecases/validate_ingredient.dart`, `lib/domain/usecases/list_categories.dart`, `lib/domain/usecases/create_category.dart`
- [x] T015 Add ingredient repository provider and base controller in `lib/presentation/providers/ingredient_repository_provider.dart`, `lib/presentation/providers/ingredient_controller.dart`
- [x] T016 [P] Add filter/selection/form providers in `lib/presentation/providers/ingredient_filters_provider.dart`, `lib/presentation/providers/ingredient_form_controller.dart`, `lib/presentation/providers/ingredient_bulk_controller.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Find Ingredients Quickly (Priority: P1) 🎯 MVP

**Goal**: Users can browse, search, and filter ingredients with clear empty/error states.

**Independent Test**: Load the list, apply search and category filters, and confirm empty/error states render correctly.

### Implementation for User Story 1

- [x] T017 [US1] Create ingredient list screen scaffold with search and filter chips in `lib/presentation/screens/ingredients/ingredient_list_screen.dart`
- [x] T018 [P] [US1] Build ingredient list tile widget in `lib/presentation/widgets/ingredients/ingredient_list_tile.dart`
- [x] T019 [US1] Wire list screen to ingredient controller and filters in `lib/presentation/screens/ingredients/ingredient_list_screen.dart`, `lib/presentation/providers/ingredient_filters_provider.dart`
- [x] T020 [US1] Add loading/empty/error UI and accessibility labels in `lib/presentation/screens/ingredients/ingredient_list_screen.dart`
- [x] T021 [US1] Add ingredient list routes and NavigationBar entry (feature-flagged) in `lib/presentation/router/app_router.dart`, `lib/presentation/screens/main_scaffold.dart`
- [x] T022 [US1] Add domain/use-case tests for list and filtering in `test/domain/list_ingredients_test.dart`
- [x] T023 [US1] Add widget tests for list screen search/filter/empty/error states in `test/widget/ingredient_list_screen_test.dart`

**Checkpoint**: User Story 1 is fully functional and testable independently

---

## Phase 4: User Story 2 - Review an Ingredient (Priority: P1)

**Goal**: Users can view ingredient details with edit/delete actions.

**Independent Test**: Open a detail view and verify fields, then delete with confirmation and see list update.

### Implementation for User Story 2

- [x] T024 [US2] Create ingredient detail screen UI with fields and actions in `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`
- [x] T025 [US2] Wire detail screen to controller with loading/empty/error states in `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`
- [x] T026 [US2] Add delete confirmation and telemetry event emission in `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`, `lib/presentation/providers/telemetry_provider.dart`
- [x] T027 [US2] Add navigation from list to detail/edit routes in `lib/presentation/screens/ingredients/ingredient_list_screen.dart`, `lib/presentation/router/app_router.dart`
- [x] T028 [US2] Add domain/use-case tests for get ingredient in `test/domain/get_ingredient_test.dart`
- [x] T029 [US2] Add widget tests for detail screen fields and delete confirmation in `test/widget/ingredient_detail_screen_test.dart`

**Checkpoint**: User Stories 1 and 2 both work independently

---

## Phase 5: User Story 3 - Add or Edit an Ingredient (Priority: P2)

**Goal**: Users can add or edit ingredients with validation, category selection, and duplicate warnings.

**Independent Test**: Submit valid/invalid forms and confirm saved data or validation feedback.

### Implementation for User Story 3

- [x] T030 [US3] Create shared ingredient form widget with validation and category picker in `lib/presentation/widgets/ingredients/ingredient_form.dart`
- [x] T031 [US3] Implement add ingredient screen using form and save flow in `lib/presentation/screens/ingredients/add_ingredient_screen.dart`
- [x] T032 [US3] Implement edit ingredient screen reusing form with prefilled data in `lib/presentation/screens/ingredients/edit_ingredient_screen.dart`
- [x] T033 [US3] Enforce duplicate-name warning and expiry date blocking in `lib/presentation/providers/ingredient_form_controller.dart`, `lib/domain/usecases/validate_ingredient.dart`
- [x] T034 [US3] Emit analytics events for add/edit saves in `lib/presentation/providers/telemetry_provider.dart`, `lib/presentation/screens/ingredients/add_ingredient_screen.dart`, `lib/presentation/screens/ingredients/edit_ingredient_screen.dart`
- [x] T035 [US3] Add domain/use-case tests for ingredient validation/duplicates in `test/domain/ingredient_validation_test.dart`
- [x] T036 [US3] Add widget tests for add/edit validation and duplicate warning in `test/widget/ingredient_form_test.dart`

**Checkpoint**: User Stories 1-3 are functional and independently testable

---

## Phase 6: User Story 4 - Quick Manage Multiple Items (Priority: P3)

**Goal**: Users can select multiple ingredients and apply bulk updates.

**Independent Test**: Select multiple items, apply bulk actions, and verify updates.

### Implementation for User Story 4

- [x] T037 [US4] Create bulk manage screen with multi-select list and action controls in `lib/presentation/screens/ingredients/ingredient_bulk_manage_screen.dart`
- [x] T038 [US4] Wire bulk manage controller to repository bulk update in `lib/presentation/providers/ingredient_bulk_controller.dart`, `lib/domain/usecases/bulk_update_ingredients.dart`
- [x] T039 [US4] Add confirmation and success/error states for bulk actions in `lib/presentation/screens/ingredients/ingredient_bulk_manage_screen.dart`
- [x] T040 [US4] Add domain/use-case tests for bulk updates in `test/domain/bulk_update_ingredients_test.dart`
- [x] T041 [US4] Add widget tests for bulk manage selection and empty-selection prompt in `test/widget/ingredient_bulk_manage_screen_test.dart`

**Checkpoint**: All user stories are complete and independently testable

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Cross-story quality and readiness

- [x] T042 [P] Run accessibility pass (Semantics labels, tap targets) across `lib/presentation/screens/ingredients/` and `lib/presentation/widgets/ingredients/`
- [x] T043 Add offline recovery and retry UX in `lib/presentation/providers/ingredient_controller.dart`, `lib/presentation/screens/ingredients/ingredient_list_screen.dart`, `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`
- [x] T044 Update quickstart validation notes in `specs/005-ingredient-management/quickstart.md`
- [x] T045 Run build_runner for new models and DTOs referenced in `specs/005-ingredient-management/quickstart.md`
- [ ] T046 Document ingredient Hive adapter migration steps in `specs/005-ingredient-management/quickstart.md`
- [ ] T047 Add backward/forward compatibility tests for ingredient Hive adapters in `test/data/ingredient_hive_migration_test.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational completion
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only
- **User Story 2 (P1)**: Depends on Foundational only (links to US1 list entry point)
- **User Story 3 (P2)**: Depends on Foundational only (edit screen may link from US2)
- **User Story 4 (P3)**: Depends on Foundational only

### Parallel Opportunities

- Setup tasks marked [P] can run in parallel
- Foundational tasks marked [P] can run in parallel
- Within each story, [P] tasks can run in parallel after dependencies complete

---

## Parallel Example: User Story 1

```text
Task: "Build ingredient list tile widget in lib/presentation/widgets/ingredients/ingredient_list_tile.dart"
Task: "Wire list screen to ingredient controller and filters in lib/presentation/screens/ingredients/ingredient_list_screen.dart"
```

## Parallel Example: User Story 2

```text
Task: "Create ingredient detail screen UI in lib/presentation/screens/ingredients/ingredient_detail_screen.dart"
Task: "Add delete confirmation and telemetry emission in lib/presentation/screens/ingredients/ingredient_detail_screen.dart"
```

## Parallel Example: User Story 3

```text
Task: "Create shared ingredient form widget in lib/presentation/widgets/ingredients/ingredient_form.dart"
Task: "Implement add ingredient screen in lib/presentation/screens/ingredients/add_ingredient_screen.dart"
```

## Parallel Example: User Story 4

```text
Task: "Create bulk manage screen in lib/presentation/screens/ingredients/ingredient_bulk_manage_screen.dart"
Task: "Wire bulk manage controller in lib/presentation/providers/ingredient_bulk_controller.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate list/search/filter and empty/error states

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Validate independently (MVP)
3. Add User Story 2 → Validate independently
4. Add User Story 3 → Validate independently
5. Add User Story 4 → Validate independently

### Parallel Team Strategy

1. Team completes Setup + Foundational together
2. After Foundational:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3/4
3. Merge and validate stories independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Avoid vague tasks or cross-story coupling that breaks independence
