# Feature Specification: Ingredient Management

**Feature Branch**: `005-ingredient-management`  
**Created**: 2025-12-29  
**Status**: Draft  
**Input**: User description: "Implement the full Ingredient Management feature set in Flutter (iOS, Material 3) as a cohesive flow. This includes all ingredient_management screens (1-4) and edit_ingredient_screen. Scope: (1) Ingredient List screen showing all ingredients with search, category/filter chips, empty/error states; (2) Ingredient Detail screen showing name, category, quantity/unit, freshness status, last updated, and actions (edit/delete); (3) Add Ingredient screen with validated form inputs (name, category, quantity, unit, freshness toggle/expiry date); (4) Bulk/Quick Manage screen to update quantities or mark multiple ingredients as used/bought; (5) Edit Ingredient screen reusing the add form with prefilled data. Use Material 3 components only (Scaffold, AppBar, Card, FilledButton, Assist/FilterChips, NavigationBar), Theme.of(context).colorScheme (no hardcoded colors), consistent spacing (8/12/16/24), and accessibility (VoiceOver labels, tap targets). Persist ingredients locally with offline support and restore state on restart. Include loading, empty, and error states for all screens, confirm destructive actions, and add basic analytics events for add/edit/delete. Keep code modular, testable, and production-ready."

## Clarifications

### Session 2025-12-29

- Q: How are categories defined for ingredients? → A: Pick from list and add custom categories.
- Q: How should duplicate ingredient names be handled? → A: Allow duplicates but warn and suggest editing existing.
- Q: How should bulk quantity updates behave? → A: Support both set and +/- adjust.
- Q: How should expiry dates in the past be handled? → A: Warn and block save.
- Q: How should freshness be determined when an expiry date is present? → A: Expiry date determines freshness if set; toggle used only when no date.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Find Ingredients Quickly (Priority: P1)

As a home cook, I want to browse my ingredients and quickly find items by name or category so I can decide what to use without scrolling.

**Why this priority**: Finding items is the primary daily task and enables all other actions.

**Independent Test**: Can be fully tested by loading the list and verifying search and filters return expected results and empty states show clearly.

**Acceptance Scenarios**:

1. **Given** ingredients exist, **When** I search by name or apply a category filter, **Then** the list shows only matching ingredients, highlights active filters, and groups results into status sections (expiring soon, in stock, out of stock).
2. **Given** no ingredients exist, **When** I open the list, **Then** I see an empty state with guidance to add ingredients.
3. **Given** a list load fails, **When** I open the list, **Then** I see an error state with a clear retry action.

---

### User Story 2 - Review an Ingredient (Priority: P1)

As a home cook, I want to view ingredient details (quantity, freshness, last updated) so I can assess whether it is usable and take action.

**Why this priority**: Users need to confirm freshness and quantity before deciding to use or restock.

**Independent Test**: Can be fully tested by opening a detail view and verifying all fields and actions display correctly.

**Acceptance Scenarios**:

1. **Given** an ingredient exists, **When** I open its details, **Then** I see name, category, quantity/unit, freshness status, and last updated time.
2. **Given** I choose delete, **When** I confirm the action, **Then** the ingredient is removed and the list updates.

---

### User Story 3 - Add or Edit an Ingredient (Priority: P2)

As a home cook, I want to add or edit an ingredient with validated inputs so my pantry stays accurate.

**Why this priority**: Accurate inventory depends on reliable data entry.

**Independent Test**: Can be fully tested by submitting valid and invalid forms and verifying saved data or validation feedback.

**Acceptance Scenarios**:

1. **Given** I open the add form, **When** I submit valid name, category, quantity, unit, and freshness data, **Then** the ingredient is saved and appears in the list.
2. **Given** I edit an ingredient, **When** I change fields and save, **Then** the updated details appear in the list and detail view.
3. **Given** required fields are missing or invalid, **When** I attempt to save, **Then** I see clear validation messages and the ingredient is not saved.

---

### User Story 4 - Quick Manage Multiple Items (Priority: P3)

As a home cook, I want to update quantities or mark multiple ingredients as used/bought so I can manage my pantry efficiently.

**Why this priority**: Batch actions reduce time spent on repetitive updates.

**Independent Test**: Can be fully tested by selecting multiple items, applying a bulk action, and verifying all selected items update.

**Acceptance Scenarios**:

1. **Given** multiple ingredients exist, **When** I select several and apply a bulk update, **Then** all selected items reflect the new quantities or status.
2. **Given** I try to apply a bulk action with no selection, **When** I confirm, **Then** I see a prompt to select at least one item.

---

### Edge Cases

- What happens when a search returns no matches?
- How does the system handle invalid quantities (negative, zero, or non-numeric)?
- What happens when a user sets an expiry date in the past (warn and block save)?
- How does the system handle duplicate ingredient names (warn and suggest editing existing)?
- What happens if a save is interrupted and the user returns later?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a searchable ingredient list with category filter chips and status sections (expiring soon, in stock, out of stock).
- **FR-002**: System MUST show loading, empty, and error states for every ingredient management screen.
- **FR-003**: System MUST allow users to view ingredient details including name, category, quantity, unit, freshness status, last updated time, and edit/delete actions.
- **FR-004**: System MUST allow users to add a new ingredient with validated inputs for name, category (select from list with ability to add custom), quantity, unit, and freshness data (toggle and optional expiry date).
- **FR-005**: System MUST allow users to edit an existing ingredient with prefilled data.
- **FR-006**: System MUST allow users to delete an ingredient with a confirmation step.
- **FR-007**: System MUST allow bulk updates to quantities (set to a value or adjust by +/-) or mark multiple selected ingredients as used or bought.
- **FR-008**: System MUST persist ingredient data locally and restore it on app restart without user action.
- **FR-009**: System MUST determine freshness from expiry date when set; otherwise use the user-entered freshness toggle.
- **FR-010**: System MUST record basic usage events for add, edit, and delete actions without storing personal data.
- **FR-011**: System MUST provide clear validation feedback for invalid or missing inputs before saving.
- **FR-012**: System MUST warn users when adding a duplicate ingredient name and offer a way to review or edit existing entries.
- **FR-013**: System MUST prevent saving an ingredient with an expiry date in the past and explain the issue to the user.

### Non-Functional Requirements (Constitution)

- **NFR-001**: Core flows MUST be usable without an internet connection and any non-critical features MUST fail gracefully.
- **NFR-002**: Each screen MUST include loading, empty, and error states and support text scaling and screen readers.
- **NFR-003**: Primary screens MUST load in under 2 seconds for a typical user with up to 500 ingredients.
- **NFR-004**: User data and configuration MUST be stored securely on the device and not exposed to other apps.
- **NFR-005**: Any analytics collected MUST be minimal, avoid personal data, and be documented for user transparency.
- **NFR-006**: Destructive actions MUST require explicit confirmation to reduce accidental data loss.
- **NFR-007**: UI MUST follow the app's standard design system, use the app theme color tokens (no hardcoded colors), and apply consistent spacing (8/12/16/24) with accessible touch targets.

### Key Entities *(include if feature involves data)*

- **Ingredient**: A pantry item with name, category, quantity, unit, freshness indicator, expiry date (optional), and last updated timestamp.
- **Category**: A label used to group and filter ingredients, chosen from a predefined list with optional custom additions.
- **Bulk Action**: A user-initiated update applied to multiple ingredients at once (quantity change, mark used/bought).
- **Usage Event**: A minimal record of add/edit/delete actions for product analytics.

## Assumptions

- The feature is single-user and operates only on local device data.
- Ingredient categories are user-selected from a predefined set with the option to add custom categories, with no external sync.
- Freshness status is derived from user input rather than automatic sensor data.

## Dependencies

- Uses existing app navigation, design system, and local storage capabilities already present in the product.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can find a specific ingredient using search or filters in under 20 seconds in 90% of tests.
- **SC-002**: At least 95% of users complete adding a new ingredient on the first attempt without validation errors.
- **SC-003**: Users can complete a bulk update of 5 items in under 60 seconds in 90% of tests.
- **SC-004**: At least 90% of delete actions are completed intentionally (confirmed) with no accidental deletions reported in usability tests.
