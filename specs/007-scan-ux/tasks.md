---

description: "Task list for Scan UX States"
---

# Tasks: Scan UX States

**Input**: Design documents from `/Users/god/Work/NauGiDay/specs/007-scan-ux/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Constitution requires tests for critical flows (domain/use-case and widget or integration coverage). Feature spec explicitly requests widget + integration tests for permission denied, gallery picker, camera unavailable, and disabled-state toggling.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.
**Constitution alignment**: Include tasks for offline resilience, UX loading/error/empty states, performance checks, accessibility (tap targets and VoiceOver labels), PII-safe logging/minimal analytics, feature flags/kill-switch tasks, and guarded async state updates where relevant.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and dependency wiring

- [X] T001 Update dependencies for permissions and integration tests in `pubspec.yaml`
- [X] T002 Verify iOS purpose strings for camera/photos in `ios/Runner/Info.plist`
- [X] T003 Add scan constants (box names, size limits) in `lib/core/constants/scan_constants.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 Add scan feature flag defaults in `lib/data/models/launch_hardening_models.dart`
- [X] T005 Update feature flag repository for `scan_enabled` in `lib/data/repositories/feature_flag_repository.dart`
- [X] T006 Expose `scanEnabled` in `lib/presentation/providers/feature_flag_provider.dart`
- [X] T007 [P] Create scan domain entities in `lib/domain/entities/scan_session.dart`
- [X] T008 [P] Create scan domain entities in `lib/domain/entities/scan_image.dart`
- [X] T009 [P] Create scan domain entities in `lib/domain/entities/scan_queue_item.dart`
- [X] T010 [P] Create scan domain entities in `lib/domain/entities/permission_state.dart`
- [X] T011 [P] Add scan DTOs in `lib/data/dtos/scan_image_dto.dart`
- [X] T012 [P] Add scan DTOs in `lib/data/dtos/scan_queue_item_dto.dart`
- [X] T013 [P] Add scan Hive adapters in `lib/data/adapters/scan_image_adapter.dart`
- [X] T014 [P] Add scan Hive adapters in `lib/data/adapters/scan_queue_item_adapter.dart`
- [X] T015 Register adapters and open scan boxes in `lib/data/local/hive_setup.dart`
- [X] T016 Add scan repository interfaces in `lib/domain/repositories/scan_queue_repository.dart`
- [X] T017 Add scan permission interfaces in `lib/domain/repositories/scan_permission_repository.dart`
- [X] T018 Implement scan storage service in `lib/data/services/scan_image_storage.dart`
- [X] T019 Implement scan picker service in `lib/data/services/scan_image_picker.dart`
- [X] T020 Implement scan permission service in `lib/data/services/scan_permission_service.dart`
- [X] T021 Implement scan queue repository in `lib/data/repositories/scan_queue_repository.dart`
- [X] T022 Implement scan permission repository in `lib/data/repositories/scan_permission_repository.dart`
- [X] T023 Add scan use cases in `lib/domain/usecases/evaluate_scan_state.dart` and `lib/domain/usecases/queue_scan_image.dart`
- [X] T024 Add scan controller/provider in `lib/presentation/providers/scan_controller.dart`
- [X] T025 Update telemetry allowlist for scan events in `lib/data/repositories/telemetry_repository.dart`
- [X] T026 [P] Add scan adapter round-trip tests in `test/data/scan_adapter_test.dart`
- [X] T027 [P] Add scan migration compatibility tests in `test/data/scan_migration_test.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Capture or Select an Image (Priority: P1) 🎯 MVP

**Goal**: Users can capture or select an image and see a preview with clear CTAs.

**Independent Test**: Open scan, capture or pick a photo, and reach preview state.

### Tests for User Story 1

- [X] T028 [P] [US1] Domain use-case test for save/validate scan image in `test/domain/scan_save_image_usecase_test.dart`
- [X] T029 [P] [US1] Widget test for gallery picker flow in `test/widget/scan_gallery_picker_test.dart`
- [X] T030 [P] [US1] Integration test for capture + gallery flow in `integration_test/scan_gallery_flow_test.dart`

### Implementation for User Story 1

- [X] T031 [US1] Align normal scan UI and preview layout in `lib/presentation/screens/scan_screen.dart`
- [X] T032 [P] [US1] Update camera controls CTAs and semantics in `lib/presentation/widgets/camera_controls_overlay.dart`
- [X] T033 [P] [US1] Update preview sheet styling and actions in `lib/presentation/widgets/scan_preview_sheet.dart`
- [X] T034 [US1] Wire gallery picker + preview state in `lib/presentation/providers/scan_controller.dart`
- [X] T035 [US1] Record scan_open, capture_photo, pick_gallery in `lib/presentation/providers/scan_controller.dart`

**Checkpoint**: User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Resolve Permission or Camera Issues (Priority: P2)

**Goal**: Users see clear guidance, retries, and fallback paths for camera issues.

**Independent Test**: Simulate initializing, camera unavailable, and permission denied states.

### Tests for User Story 2

- [X] T036 [P] [US2] Domain use-case test for permission-driven scan state in `test/domain/scan_state_usecase_test.dart`
- [X] T037 [P] [US2] Widget test for permission denied UI in `test/widget/scan_permission_denied_test.dart`
- [X] T038 [P] [US2] Update widget test for camera unavailable UI in `test/widget/scan_camera_unavailable_test.dart`
- [X] T039 [P] [US2] Integration test for camera unavailable retry in `integration_test/scan_camera_unavailable_flow_test.dart`

### Implementation for User Story 2

- [X] T040 [US2] Implement initializing state skeleton in `lib/presentation/screens/scan_screen.dart`
- [X] T041 [US2] Implement camera unavailable state with retry and fallback in `lib/presentation/screens/scan_screen.dart`
- [X] T042 [US2] Implement permission denied state + settings deep link in `lib/presentation/screens/scan_screen.dart`
- [X] T043 [US2] Record permission_denied, open_settings, scan_retry in `lib/presentation/providers/scan_controller.dart`

**Checkpoint**: User Story 2 flows work independently of other stories

---

## Phase 5: User Story 3 - Recover from Errors and Offline Use (Priority: P3)

**Goal**: Capture/pick failures are recoverable and offline scans are queued locally.

**Independent Test**: Simulate failures and offline mode, confirm queued status.

### Tests for User Story 3

- [X] T044 [P] [US3] Domain use-case test for offline queueing in `test/domain/scan_queue_usecase_test.dart`
- [X] T045 [P] [US3] Widget test for offline queued status in `test/widget/scan_offline_queue_test.dart`
- [X] T046 [P] [US3] Integration test for offline queue persistence in `integration_test/scan_offline_queue_test.dart`

### Implementation for User Story 3

- [X] T047 [US3] Add non-fatal error reporting on capture/pick failures in `lib/presentation/providers/scan_controller.dart`
- [X] T048 [US3] Persist queued scan items in `lib/data/repositories/scan_queue_repository.dart`
- [X] T049 [US3] Show queued status and retry actions in `lib/presentation/widgets/scan_preview_sheet.dart`

**Checkpoint**: User Story 3 works independently with offline queueing

---

## Phase 6: User Story 4 - Respect Feature Disablement (Priority: P4)

**Goal**: Disabled state shows explanation and alternate entry points.

**Independent Test**: Toggle scan flag off and verify alternate paths.

### Tests for User Story 4

- [X] T050 [P] [US4] Domain use-case test for disabled scan state in `test/domain/scan_disabled_state_usecase_test.dart`
- [X] T051 [P] [US4] Widget test for disabled state UI in `test/widget/scan_disabled_state_test.dart`
- [X] T052 [P] [US4] Integration test for disabled state navigation in `integration_test/scan_disabled_state_flow_test.dart`

### Implementation for User Story 4

- [X] T053 [US4] Gate scan screen via feature flag and render disabled UI in `lib/presentation/screens/scan_screen.dart`
- [X] T054 [US4] Record scan_disabled event in `lib/presentation/providers/scan_controller.dart`

**Checkpoint**: User Story 4 works independently with scan disabled

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T055 [P] Run codegen for new entities/DTOs referenced in `lib/domain/entities/scan_image.dart`
- [X] T056 [P] Document profiling notes in `specs/007-scan-ux/quickstart.md`
- [X] T057 [P] Validate quickstart steps and adjust notes in `specs/007-scan-ux/quickstart.md`
- [X] T058 Run full test suite (widget + integration) covering scan flows in `specs/007-scan-ux/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Independent of US1
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Independent of US1/US2
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - Independent of US1/US2/US3

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- State management before UI wiring
- Core implementation before integration and polish

### Parallel Opportunities

- Foundational entities/DTOs/adapters marked [P] can run in parallel
- Widget and integration tests per user story marked [P] can run in parallel
- UI widget updates in separate files can run in parallel after foundational state is ready

---

## Parallel Example: User Story 1

```bash
# Launch tests for User Story 1 together:
Task: "Domain use-case test for save/validate scan image in test/domain/scan_save_image_usecase_test.dart"
Task: "Widget test for gallery picker flow in test/widget/scan_gallery_picker_test.dart"
Task: "Integration test for capture + gallery flow in integration_test/scan_gallery_flow_test.dart"

# Launch UI component updates in parallel:
Task: "Update camera controls CTAs and semantics in lib/presentation/widgets/camera_controls_overlay.dart"
Task: "Update preview sheet styling and actions in lib/presentation/widgets/scan_preview_sheet.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Add User Story 4 → Test independently → Deploy/Demo

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
   - Developer D: User Story 4
3. Stories complete and integrate independently
