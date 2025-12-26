# NauGiDay Roadmap (Current Baseline)

This roadmap turns the existing specs and task lists into a clear delivery plan.
It is organized as milestones with outcomes, key tasks, and definition-of-done checks.

## Enhancement Summary (Spec Kit Inputs)

- Add cooking steps to the add-recipe flow (UI + controller + persistence + tests).
- Add local recipe image attachments with limits, permissions, and offline viewing.
- Add gallery picker + attach flow for recipe images (camera or library).
- Harden persistence with schema versioning, migration tests, and perf checks.
- Integrate real AI provider (replace fake service, add parsing/retry/error handling).
- Implement shopping list feature (data model, persistence, CTA wiring).
- Publish a testing strategy spec and close missing integration tests.

## Baseline (What Exists Today)

- Core flows: scan -> suggestions -> detail, plus My Recipes and create recipe.
- Local persistence via Hive, DTOs, repositories, and use cases.
- UI/UX polish: skeletons, hero transitions, error/empty states, debug toggles.
- AI service is stubbed (fake responses).
- Shopping list is a placeholder screen.

## Milestone 1 - Recipe Steps (Add Workflow US2) [Current]

**Goal**: Users can add, reorder, and persist cooking steps.

**Key work**
- Steps list UI with add/edit/delete/reorder.
- Controller support for ordered steps.
- Repository round-trip for steps.
- Widget test for step ordering.

**Definition of done**
- Steps preserve order after save and app restart.
- Widget test passes for reorder and save.

**References**
- `specs/003-recipe-add-workflow/spec.md`
- `specs/003-recipe-add-workflow/tasks.md`

## Milestone 2 - Recipe Images (Add Workflow US3) [Planned]

**Goal**: Users can attach images locally with limits and offline viewing.

**Key work**
- Image picker integration with permission handling.
- Preview grid with remove and cap messaging.
- Local image storage + metadata for future sync.
- Widget + integration tests for caps, permission denial, and offline reopen.
- Gallery picker + camera capture for recipe attachments (not just scan flow).

**Definition of done**
- Images persist offline and render after restart.
- Limits enforced (5 images, 5MB cap) with clear messaging.
- Permission denial handled within 2 seconds and save remains possible.
- Users can attach images from camera or gallery in the add-recipe flow.

**References**
- `specs/003-recipe-add-workflow/spec.md`
- `specs/003-recipe-add-workflow/tasks.md`

## Milestone 3 - Persistence Hardening [Planned]

**Goal**: Long-term safety for local data across updates and failures.

**Key work**
- Schema versioning and default migrations in repository and adapters.
- Migration tests for legacy entries missing new fields.
- Performance check for save/edit/delete (<2 seconds).
- QA checklist for corruption recovery.

**Definition of done**
- Migration tests pass with legacy data.
- Perf check documented in research or quickstart docs.
- Recovery UI verified with QA checklist.

**References**
- `specs/001-recipe-persistence/spec.md`
- `specs/001-recipe-persistence/tasks.md`

## Milestone 4 - Real AI Integration [Planned]

**Goal**: Replace fake AI with Gemini (or similar) service.

**Key work**
- Add API client package and key handling.
- Implement AI service with JSON parsing and retry fallback.
- Wire to suggestions flow and error handling.
- Add tests for parsing failures and empty responses.

**Definition of done**
- Real API produces recipes for typical ingredient sets.
- Failures surface cleanly with retry paths.
- No secrets committed to repo.

**References**
- `my_specs/ai_integration_spec.md`

## Milestone 5 - Shopping List Feature [Planned]

**Goal**: Convert missing ingredients into a usable shopping list.

**Key work**
- Define data model and storage strategy.
- Add create/update/delete list items.
- Wire "Add missing items to shopping list" CTA.
- Provide empty/error states and tests.

**Definition of done**
- Missing ingredients flow adds items to list.
- List persists offline and is editable.

**References**
- `lib/presentation/screens/shopping_list_screen.dart`

## Milestone 6 - Testing Strategy + Coverage [Planned]

**Goal**: Formalize testing strategy and close key gaps.

**Key work**
- Create testing strategy spec (unit, widget, integration).
- Ensure integration tests for offline save/reopen and images.
- Add golden tests only if needed for critical UI.

**Definition of done**
- Testing strategy doc exists and is followed.
- Required tests in specs are implemented and passing.

## Dependencies

- Milestone 1 and 2 build on existing add-recipe flow and persistence.
- Milestone 3 should follow 1 and 2 so migrations cover new fields.
- Milestone 4 can run in parallel with Milestone 3 if desired.
- Milestone 5 depends on decision about shopping list data model.

## Decisions Required

| Decision | Owner | Status | Due date | Notes |
| --- | --- | --- | --- | --- |
| AI provider choice (Gemini vs. other) and cost limits | TBD | Pending | TBD | Align with budget and platform constraints. |
| Image storage location and cleanup strategy | TBD | Pending | TBD | Define retention policy and cleanup triggers. |
| Shopping list data model (standalone vs. derived) | TBD | Pending | TBD | Impacts persistence and UX. |
| Test environment for offline and permission scenarios | TBD | Pending | TBD | Decide emulators, mocks, or device lab. |

## Suggested Execution Order

1) Milestone 1 (Steps)
2) Milestone 2 (Images)
3) Milestone 3 (Persistence hardening)
4) Milestone 4 (AI integration)
5) Milestone 5 (Shopping list)
6) Milestone 6 (Testing strategy and coverage)
