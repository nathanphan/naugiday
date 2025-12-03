---

description: "Task list for UI/UX improvements"

---

# Tasks: UI/UX Improvements

**Input**: Design documents from `/specs/002-ui-ux-improvements/`  
**Prerequisites**: plan.md (required), spec.md (user stories), research.md, data-model.md, quickstart.md  
**Tests**: Widget tests for loading/error/empty states, interactions (swipe/undo, save/share), and debug toggles are REQUIRED; golden tests optional.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.  
**Constitution alignment**: Maintain clean architecture, offline resilience, performance (≤16ms frames), dark mode/text scaling, and guarded debug toggles.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Parallelizable (different files, no shared deps)
- **[Story]**: [US1]/[US2]/[US3] from spec priorities
- Include exact file paths in descriptions

---

## Phase 1: Setup

- [X] T001 Run `flutter pub get` and ensure build_runner/freezed/riverpod codegen still healthy
- [X] T002 Verify assets (`AppAssets.foodPlaceholder`, `AppAssets.emptyState`) available for new states; no new dependencies needed

---

## Phase 2: Foundational (UI primitives)

- [X] T003 Create shared shimmer/skeleton widgets and animation constants in `lib/presentation/widgets/skeletons.dart`
- [X] T004 Add animation/duration/curve tokens in `lib/presentation/theme/app_theme.dart` (or a new `theme/animation_tokens.dart`)

---

## Phase 3: User Story 1 - Polished loading and motion (P1)

**Goal**: Show skeletons/shimmer and smooth hero/entrance animations during loading.

**Independent Test**: Trigger loading on Home, Suggestions, Detail, My Recipes; see skeletons/shimmer and smooth hero/entrance without layout shift.

### Implementation

- [X] T005 [US1] Apply shared skeletons to Suggestions grid loading state in `lib/presentation/screens/recipe_suggestions_screen.dart`
- [X] T006 [US1] Add skeletons to Home “Suggested Today” row in `lib/presentation/screens/home_screen.dart`
- [X] T007 [US1] Add skeletons to Recipe Detail header/steps in `lib/presentation/screens/recipe_detail_screen.dart`
- [X] T008 [US1] Enhance My Recipes loading with shimmer using shared skeletons in `lib/presentation/screens/my_recipes_screen.dart`
- [X] T009 [US1] Add hero transition from recipe cards/placeholders to detail header in `lib/presentation/screens/recipe_suggestions_screen.dart` and `lib/presentation/screens/recipe_detail_screen.dart`
- [X] T010 [US1] Add entrance animations (AnimatedSwitcher/slide+fade) for Suggestions grid and My Recipes list in respective screens

### Tests

- [X] T011 [P] [US1] Widget test: Suggestions loading shows two-column skeletons (no spinners) in `test/widget/recipe_suggestions_loading_test.dart`
- [X] T012 [P] [US1] Widget test: Hero/entrance animation from card to detail renders without layout shift in `test/widget/recipe_detail_hero_test.dart`

---

## Phase 4: User Story 2 - Clear errors and empty states with recovery (P2)

**Goal**: Standardized illustrated error/empty states with recovery CTAs and snackbars/toasts.

**Independent Test**: Force empty/error for suggestions, camera unavailable, storage error; see illustrated states with CTAs and snackbars; no crashes.

### Implementation

- [X] T013 [US2] Standardize Suggestions empty/error cards with “Retry/Rescan/Clear filters” CTAs in `lib/presentation/screens/recipe_suggestions_screen.dart`
- [X] T014 [US2] Add camera failure state with settings + retry actions in `lib/presentation/screens/scan_screen.dart`
- [X] T015 [US2] Wrap My Recipes storage error in illustrated repair card retaining existing data in `lib/presentation/screens/my_recipes_screen.dart`
- [X] T016 [US2] Add snackbars/toasts for AI fetch errors and save/update/delete outcomes in `lib/presentation/screens/recipe_suggestions_screen.dart` and `lib/presentation/screens/create_recipe_screen.dart`

### Tests

- [X] T017 [P] [US2] Widget test: Suggestions empty/error states show CTAs in `test/widget/recipe_suggestions_empty_error_test.dart`
- [X] T018 [P] [US2] Widget test: Camera unavailable shows settings/retry actions in `test/widget/scan_camera_unavailable_test.dart`
- [X] T019 [P] [US2] Widget test: My Recipes storage error shows repair/retry card preserving data in `test/widget/my_recipes_error_state_test.dart`

---

## Phase 5: User Story 3 - Enhanced interactions and debug toggles (P3)

**Goal**: Ingredient labeling, swipe/undo, favorite/share, and debug toggles for QA without production impact.

**Independent Test**: Edit labels before generate; swipe delete with undo; favorite/share; toggle debug modes to force states safely.

### Implementation

- [X] T020 [US3] Add ingredient label editing in Scan preview and propagate to detected banner in `lib/presentation/screens/scan_screen.dart` and related widgets
- [X] T021 [US3] Add dismissible rows with confirm + undo, and favorite/pin on long-press in `lib/presentation/screens/my_recipes_screen.dart`
- [X] T022 [US3] Add save/unsave and share actions plus “Add missing items to shopping list” CTA in `lib/presentation/screens/recipe_detail_screen.dart`
- [X] T023 [US3] Implement debug toggles (suggestions loading/error/empty, storage error/empty, camera unavailable/slow) guarded by dev panel in `lib/core/debug/debug_toggles.dart` and apply in screens/providers

### Tests

- [X] T024 [P] [US3] Widget test: Ingredient labels propagate to detected banner in `test/widget/scan_label_propagation_test.dart`
- [X] T025 [P] [US3] Widget test: Swipe delete with undo and favorite/pin toggle in `test/widget/my_recipes_interactions_test.dart`
- [X] T026 [P] [US3] Widget test: Detail save/unsave + share actions available and stable in `test/widget/recipe_detail_actions_test.dart`
- [X] T027 [P] [US3] Widget/dev-mode test: Debug toggles force loading/error/empty/camera/storage states without affecting production flag in `test/widget/debug_toggles_test.dart`

---

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T028 Update theme tokens (typography spacing/radius/contrast) for chips/pills/bottom surfaces in `lib/presentation/theme/app_theme.dart`
- [ ] T029 Profile animations/skeleton performance (p95 frame time ≤16ms) and record in `specs/002-ui-ux-improvements/research.md` or `quickstart.md`
- [ ] T030 Update docs with QA toggle usage and test instructions in `specs/002-ui-ux-improvements/quickstart.md`

---

## Dependencies & Execution Order

- Setup (Phase 1) → Foundational (Phase 2) → US1 (Phase 3) → US2 (Phase 4) → US3 (Phase 5) → Polish (Phase 6)

## Parallel Examples

- Skeleton/animation tests (T011/T012) can run in parallel.  
- Error/empty state tests (T017–T019) can run in parallel.  
- Interaction/debug tests (T024–T027) can run in parallel after corresponding implementations.

## Implementation Strategy

- MVP first: deliver US1 (loading/motion) after setup/foundations.  
- Incrementally add US2 (error/empty) then US3 (interactions/dev toggles).  
- Conclude with polish (theme tokens, profiling, docs).
