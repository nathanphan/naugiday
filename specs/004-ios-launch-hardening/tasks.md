---

description: "Task list for Day-1 Launch Hardening (iOS)"
---

# Tasks: Day-1 Launch Hardening (iOS)

**Input**: Design documents from `/specs/004-ios-launch-hardening/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by constitution for critical flows; include unit/widget
tests per user story and manual QA per quickstart checklist.

**Organization**: Tasks are grouped by user story to enable independent
implementation and testing of each story.
**Constitution alignment**: Include tasks for offline resilience, UX
loading/error/empty states, performance checks, accessibility (tap targets and
VoiceOver labels), PII-safe logging/minimal analytics, feature flags/kill-switch
controls, and guarded async state updates where relevant.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Cross-cutting constants and shared definitions

- [X] T001 [P] Add launch hardening constants in `lib/core/constants/launch_hardening_constants.dart`
- [X] T002 [P] Add shared launch hardening models in `lib/data/models/launch_hardening_models.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 Create privacy disclosure entity in `lib/domain/entities/privacy_disclosure_item.dart`
- [X] T004 [P] Create telemetry event entity in `lib/domain/entities/telemetry_event.dart`
- [X] T005 [P] Create feature flag entity in `lib/domain/entities/feature_flag.dart`
- [X] T006 [P] Create release checklist entity in `lib/domain/entities/release_checklist_item.dart`
- [X] T007 [P] Create rollback plan entity in `lib/domain/entities/rollback_plan_step.dart`
- [X] T008 Create feature flag use case in `lib/domain/usecases/fetch_feature_flags.dart`
- [X] T009 [P] Create telemetry use case in `lib/domain/usecases/record_telemetry_event.dart`
- [X] T010 [P] Create checklist validation use case in `lib/domain/usecases/validate_release_checklist.dart`
- [X] T011 Create feature flag repository interface in `lib/domain/repositories/feature_flag_repository.dart`
- [X] T012 [P] Create telemetry repository interface in `lib/domain/repositories/telemetry_repository.dart`
- [X] T013 [P] Create release checklist repository interface in `lib/domain/repositories/release_checklist_repository.dart`
- [X] T014 Implement remote config service in `lib/data/services/remote_config_service.dart`
- [X] T015 [P] Implement telemetry service in `lib/data/services/telemetry_service.dart`
- [X] T016 [P] Implement crash reporting service in `lib/data/services/crash_reporting_service.dart`
- [X] T017 [P] Implement logging service guard in `lib/data/services/logging_service.dart`
- [X] T018 Implement feature flag repository in `lib/data/repositories/feature_flag_repository.dart`
- [X] T019 [P] Implement telemetry repository in `lib/data/repositories/telemetry_repository.dart`
- [X] T020 [P] Implement release checklist repository in `lib/data/repositories/release_checklist_repository.dart`
- [X] T021 Register launch hardening storage/cache in `lib/data/local/hive_setup.dart`
- [X] T022 Add feature flag provider in `lib/presentation/providers/feature_flag_provider.dart`
- [X] T023 [P] Add telemetry provider in `lib/presentation/providers/telemetry_provider.dart`
- [X] T024 [P] Add release checklist provider in `lib/presentation/providers/release_checklist_provider.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Submission-Ready Compliance (Priority: P1) 🎯 MVP

**Goal**: App Store compliance assets plus release checklist and rollback plan

**Independent Test**: A reviewer can verify purpose strings, privacy policy URL,
App Privacy details, and release checklist in one review session.

### Implementation for User Story 1

### Tests for User Story 1

- [X] T025 [P] [US1] Add unit test for checklist validation in `test/unit/release_checklist_validation_test.dart`
- [X] T026 [P] [US1] Add widget test for checklist UI in `test/widget/release_checklist_screen_test.dart`

### Implementation for User Story 1

- [X] T027 [US1] Document App Store compliance details in `specs/004-ios-launch-hardening/app-store-compliance.md`
- [X] T028 [US1] Update iOS purpose strings in `ios/Runner/Info.plist`
- [X] T029 [US1] Surface privacy policy URL in `lib/presentation/screens/home_screen.dart`
- [X] T030 [US1] Create release checklist doc in `specs/004-ios-launch-hardening/release-checklist.md`
- [X] T031 [US1] Create rollback plan doc in `specs/004-ios-launch-hardening/rollback-plan.md`
- [X] T032 [US1] Build release checklist screen in `lib/presentation/screens/release_checklist_screen.dart`
- [X] T033 [US1] Register checklist route in `lib/presentation/router/app_router.dart`
- [X] T034 [US1] Add checklist entry point in `lib/presentation/screens/main_scaffold.dart`

**Checkpoint**: User Story 1 is reviewable and App Store compliance assets are ready

---

## Phase 4: User Story 2 - Operational Safety Controls (Priority: P2)

**Goal**: Crash reporting, minimal analytics, PII-safe logging, and remote kill switches

**Independent Test**: A tester can disable AI/images remotely, confirm event
tracking for the three CTAs and screen views, and see crash reporting active
without PII.

### Implementation for User Story 2

### Tests for User Story 2

- [X] T035 [P] [US2] Add unit test for feature flag cache fallback in `test/unit/feature_flag_cache_test.dart`
- [X] T036 [P] [US2] Add unit test for telemetry filtering in `test/unit/telemetry_filter_test.dart`
- [X] T037 [P] [US2] Add widget test for kill-switch UI states in `test/widget/feature_flags_ui_test.dart`

### Implementation for User Story 2

- [X] T038 [US2] Initialize crash reporting at app start in `lib/main.dart`
- [X] T039 [US2] Enforce default-off logging in `lib/core/debug/debug_toggles.dart`
- [X] T040 [US2] Fetch remote feature flags on startup in `lib/main.dart`
- [X] T041 [US2] Use cached feature flags when offline in `lib/data/services/remote_config_service.dart`
- [X] T042 [US2] Avoid sending telemetry while offline in `lib/data/services/telemetry_service.dart`
- [X] T043 [US2] Gate AI calls via feature flags in `lib/data/datasources/fake_ai_recipe_service.dart`
- [X] T044 [US2] Gate image attachments via feature flags in `lib/presentation/screens/create_recipe_screen.dart`
- [X] T045 [US2] Show AI-disabled messaging in `lib/presentation/screens/recipe_suggestions_screen.dart`
- [X] T046 [US2] Show image-disabled messaging in `lib/presentation/widgets/recipe_image_grid.dart`
- [X] T047 [US2] Emit screen_view analytics in `lib/presentation/router/app_router.dart`
- [X] T048 [US2] Emit CTA analytics in `lib/presentation/widgets/home_cta_card.dart`
- [X] T049 [US2] Emit CTA analytics in `lib/presentation/widgets/quick_actions_row.dart`
- [X] T050 [US2] Emit save-recipe analytics in `lib/presentation/screens/create_recipe_screen.dart`
- [X] T051 [US2] Emit generate-recipe analytics in `lib/presentation/screens/recipe_suggestions_screen.dart`

**Checkpoint**: Telemetry, logging, and kill switches behave as specified

---

## Phase 5: User Story 3 - Accessible and Responsive Experience (Priority: P3)

**Goal**: VoiceOver coverage, tap target sizing, and performance budget checklist

**Independent Test**: A tester can complete primary flows using VoiceOver and
verify tap targets + performance budget compliance.

### Implementation for User Story 3

### Tests for User Story 3

- [X] T052 [P] [US3] Add widget test for VoiceOver labels in `test/widget/accessibility_labels_test.dart`
- [X] T053 [P] [US3] Add widget test for tap target sizing in `test/widget/tap_target_sizing_test.dart`

### Implementation for User Story 3

- [X] T054 [US3] Add VoiceOver labels for primary CTAs in `lib/presentation/widgets/home_cta_card.dart`
- [X] T055 [US3] Add VoiceOver labels for scan controls in `lib/presentation/screens/scan_screen.dart`
- [X] T056 [US3] Add VoiceOver labels for recipe actions in `lib/presentation/screens/create_recipe_screen.dart`
- [X] T057 [US3] Add VoiceOver labels for suggested recipes in `lib/presentation/widgets/suggested_recipe_card.dart`
- [X] T058 [US3] Enforce tap target sizing in `lib/presentation/widgets/quick_actions_row.dart`
- [X] T059 [US3] Enforce tap target sizing in `lib/presentation/widgets/ingredient_tile.dart`
- [X] T060 [US3] Add performance budget checklist in `specs/004-ios-launch-hardening/performance-checklist.md`

**Checkpoint**: Accessibility and performance budget checklist are complete

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final docs alignment and release readiness

- [X] T061 [P] Add checklist references to `specs/004-ios-launch-hardening/quickstart.md`
- [X] T062 Add release checklist sign-off section in `specs/004-ios-launch-hardening/release-checklist.md`
- [X] T063 Add CI workflow for tests/lint/format/release build in `.github/workflows/ios_ci.yml`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - no dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - no dependencies on other stories
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - no dependencies on other stories

### Parallel Execution Examples

- **US1**: T025 (compliance doc) and T026 (Info.plist) can run in parallel
- **US2**: T040 (screen_view) and T041 (CTA analytics) can run in parallel
- **US3**: T045 (CTA labels) and T051 (performance checklist doc) can run in parallel

## Implementation Strategy

- Deliver P1 compliance assets first, then safety controls, then accessibility/performance.
- Keep kill switches and telemetry minimal to stay shippable.
- Use release checklist and rollback plan docs as the acceptance anchor for submission.
