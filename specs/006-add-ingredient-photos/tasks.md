---

description: "Task list for ingredient photo attachments"
---

# Tasks: Add Ingredient Photos

**Input**: Design documents from `/Users/god/Work/NauGiDay/specs/006-add-ingredient-photos/`
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

- [x] T001 Add image picking dependency and iOS purpose strings in `pubspec.yaml`, `ios/Runner/Info.plist`
- [x] T002 [P] Add ingredient photo feature flag storage in `lib/data/models/launch_hardening_models.dart`, `lib/data/repositories/feature_flag_repository.dart`
- [x] T003 [P] Expose ingredient photo feature flag in `lib/presentation/providers/feature_flag_provider.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain/data foundations required by all photo flows

- [x] T004 Add photo limit constant in `lib/core/constants/ingredient_constants.dart`
- [x] T005 [P] Add ingredient photo entity and link to ingredient entity in `lib/domain/entities/ingredient_photo.dart`, `lib/domain/entities/pantry_ingredient.dart`
- [x] T006 Update ingredient validation for photo count and missing references in `lib/domain/usecases/validate_ingredient.dart`
- [x] T007 [P] Add ingredient photo DTO and include it in pantry ingredient DTO in `lib/data/dtos/ingredient_photo_dto.dart`, `lib/data/dtos/pantry_ingredient_dto.dart`
- [x] T008 [P] Update Hive adapters and setup for photo fields in `lib/data/adapters/pantry_ingredient_adapter.dart`, `lib/data/local/hive_setup.dart`
- [x] T009 Create photo storage service for copy/delete/exists in `lib/data/services/ingredient_photo_storage.dart`
- [x] T010 Update ingredient repository to persist photo refs and file ops in `lib/data/repositories/local_ingredient_repository.dart`
- [x] T011 Add photo storage provider wiring in `lib/presentation/providers/ingredient_repository_provider.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Add Ingredient With Photos (Priority: P1) 🎯 MVP

**Goal**: Users can attach up to three photos during ingredient creation.

**Independent Test**: Add an ingredient with 1-3 photos, confirm thumbnails and persisted photos after restart.

### Tests for User Story 1

- [x] T012 [P] [US1] Add domain tests for photo limit/validation in `test/domain/ingredient_photo_validation_test.dart`
- [x] T013 [P] [US1] Add widget tests for add form photo picking/limit UI in `test/widget/ingredient_form_photo_test.dart`

### Implementation for User Story 1

- [x] T014 [US1] Extend form state and actions for photo list/picker in `lib/presentation/providers/ingredient_form_controller.dart`
- [x] T015 [US1] Build photo picker UI (add tile, thumbnails, delete, limit) in `lib/presentation/widgets/ingredients/ingredient_form.dart`
- [x] T016 [US1] Integrate photo saving into add flow in `lib/presentation/screens/ingredients/add_ingredient_screen.dart`
- [x] T017 [US1] Add permission-denied and missing-file error UI in `lib/presentation/widgets/ingredients/ingredient_form.dart`

**Checkpoint**: User Story 1 is fully functional and testable independently

---

## Phase 4: User Story 2 - Edit Ingredient Photos (Priority: P2)

**Goal**: Users can add or remove photos on existing ingredients.

**Independent Test**: Edit an ingredient to add/remove photos, then confirm the saved set matches changes after restart.

### Tests for User Story 2

- [x] T018 [P] [US2] Add widget tests for edit photo add/remove in `test/widget/ingredient_edit_photos_test.dart`

### Implementation for User Story 2

- [x] T019 [US2] Prefill existing photos and enable removal in edit flow in `lib/presentation/screens/ingredients/edit_ingredient_screen.dart`, `lib/presentation/providers/ingredient_form_controller.dart`
- [x] T020 [US2] Ensure photo deletions remove local files in `lib/data/repositories/local_ingredient_repository.dart`

**Checkpoint**: User Stories 1 and 2 both work independently

---

## Phase 5: User Story 3 - View Full-Size Photos (Priority: P3)

**Goal**: Users can view a full-size photo by tapping a thumbnail.

**Independent Test**: Tap a thumbnail and confirm a full-size viewer opens and closes reliably.

### Tests for User Story 3

- [x] T021 [P] [US3] Add widget tests for full-size photo viewer in `test/widget/ingredient_photo_viewer_test.dart`

### Implementation for User Story 3

- [x] T022 [US3] Add full-size photo viewer widget/modal in `lib/presentation/widgets/ingredients/ingredient_photo_viewer.dart`
- [x] T023 [US3] Wire thumbnail tap to viewer in `lib/presentation/widgets/ingredients/ingredient_form.dart`, `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`

**Checkpoint**: All user stories are complete and independently testable

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cross-story quality and readiness

- [x] T024 [P] Add accessibility labels and tap targets for photo controls in `lib/presentation/widgets/ingredients/ingredient_form.dart`, `lib/presentation/widgets/ingredients/ingredient_photo_viewer.dart`
- [x] T025 Add thumbnail decoding size for performance in `lib/presentation/widgets/ingredients/ingredient_form.dart`, `lib/presentation/screens/ingredients/ingredient_detail_screen.dart`
- [x] T026 Document photo migration steps in `specs/006-add-ingredient-photos/quickstart.md`
- [x] T027 Add Hive migration tests for ingredient photos in `test/data/ingredient_photo_migration_test.dart`
- [x] T028 Run build_runner and commit generated files in `lib/data/dtos/ingredient_photo_dto.g.dart`, `lib/domain/entities/ingredient_photo.freezed.dart`, `lib/domain/entities/ingredient_photo.g.dart`
- [x] T029 Add missing-photo recovery UI and actions in `lib/presentation/widgets/ingredients/ingredient_form.dart`, `lib/presentation/screens/ingredients/add_ingredient_screen.dart`, `lib/presentation/screens/ingredients/edit_ingredient_screen.dart`
- [x] T030 Add photo loading/empty/error helper text and text scaling checks in `lib/presentation/widgets/ingredients/ingredient_form.dart`, `specs/006-add-ingredient-photos/quickstart.md`
- [x] T031 Add compliance verification checklist for crash reporting/PII/secrets/AI in `specs/006-add-ingredient-photos/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational completion
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational only
- **User Story 2 (P2)**: Depends on Foundational only (shares form state with US1)
- **User Story 3 (P3)**: Depends on Foundational only (viewer reuses US1 thumbnails)

### Parallel Opportunities

- Setup tasks marked [P] can run in parallel
- Foundational tasks marked [P] can run in parallel
- Within each story, [P] tasks can run in parallel after dependencies complete

---

## Parallel Example: User Story 1

```text
Task: "Add domain tests for photo limit/validation in test/domain/ingredient_photo_validation_test.dart"
Task: "Add widget tests for add form photo picking/limit UI in test/widget/ingredient_form_photo_test.dart"
```

## Parallel Example: User Story 2

```text
Task: "Add widget tests for edit photo add/remove in test/widget/ingredient_edit_photos_test.dart"
Task: "Prefill existing photos and enable removal in lib/presentation/screens/ingredients/edit_ingredient_screen.dart"
```

## Parallel Example: User Story 3

```text
Task: "Add widget tests for full-size photo viewer in test/widget/ingredient_photo_viewer_test.dart"
Task: "Add full-size photo viewer widget in lib/presentation/widgets/ingredients/ingredient_photo_viewer.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Validate add flow with photo limits and persistence

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Validate independently (MVP)
3. Add User Story 2 → Validate independently
4. Add User Story 3 → Validate independently

### Parallel Team Strategy

1. Team completes Setup + Foundational together
2. After Foundational:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Merge and validate stories independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Avoid vague tasks or cross-story coupling that breaks independence
