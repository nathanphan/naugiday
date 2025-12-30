# Feature Specification: Add Ingredient Photos

**Feature Branch**: `006-add-ingredient-photos`  
**Created**: 2025-12-30  
**Status**: Draft  
**Input**: User description: "I want to have ability to add image/photo to ingredient. Either upload from gallery or take photo. It should be working for add ingredient, edit ingredient. max is 3 photos, there are thumnails with delete icon. when thumnail is clicked, user can view actual photo"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Add Ingredient With Photos (Priority: P1)

As a home cook, I want to attach photos when adding an ingredient so I can visually confirm what I stored.

**Why this priority**: Photo attachment during creation is the core value of the feature.

**Independent Test**: Can be fully tested by adding a new ingredient with up to three photos and confirming they appear in the ingredient details.

**Acceptance Scenarios**:

1. **Given** the add ingredient form, **When** I add one or more photos and save, **Then** the ingredient is created with those photos attached.
2. **Given** I have already added three photos, **When** I try to add another, **Then** the system prevents it and clearly explains the limit.

---

### User Story 2 - Edit Ingredient Photos (Priority: P2)

As a user, I want to add or remove photos on an existing ingredient so the photos stay accurate over time.

**Why this priority**: Editing keeps ingredient records current and avoids stale images.

**Independent Test**: Can be fully tested by editing an ingredient to add and remove photos, then verifying the saved set matches the changes.

**Acceptance Scenarios**:

1. **Given** an ingredient with photos, **When** I delete a thumbnail and save, **Then** the photo is removed from that ingredient.
2. **Given** an ingredient with fewer than three photos, **When** I add new photos and save, **Then** the ingredient retains the updated set.

---

### User Story 3 - View Full-Size Photos (Priority: P3)

As a user, I want to tap a thumbnail to view the full photo so I can see details clearly.

**Why this priority**: Full-size viewing improves usefulness without cluttering the form.

**Independent Test**: Can be fully tested by tapping a thumbnail and confirming the full image opens and closes reliably.

**Acceptance Scenarios**:

1. **Given** an ingredient with thumbnails, **When** I tap a thumbnail, **Then** a full-size view opens for that photo.

---

### Edge Cases

- What happens when camera or photo access is denied or unavailable?
- How does the system handle a photo that fails to load or is missing from local storage?
- What happens when the user cancels photo selection after opening the picker?
- How does the system handle very large images that could slow down the form?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST allow users to add photos when creating an ingredient.
- **FR-002**: The system MUST allow users to add or remove photos when editing an ingredient.
- **FR-003**: The system MUST support photo selection from both the camera and the device photo library.
- **FR-004**: The system MUST enforce a maximum of three photos per ingredient.
- **FR-005**: The system MUST show selected photos as thumbnails with a visible delete action on each thumbnail.
- **FR-006**: Users MUST be able to open a full-size view by tapping a thumbnail.
- **FR-007**: The system MUST persist attached photos so they remain available after app restart.
- **FR-008**: The system MUST handle permission denial or unavailable camera/library with a clear, user-facing message and safe fallback.
- **FR-009**: The system MUST prevent saving an ingredient with broken photo references and provide a recovery path (remove or reselect).

### Non-Functional Requirements (Constitution)

- **NFR-001**: Feature MUST work offline for core user flows; photo attachment and viewing MUST be available without a network connection.
- **NFR-002**: UI MUST include loading, empty, and error states and support dark mode + text scaling.
- **NFR-003**: Photo picker access and full-size viewing MUST complete within 2 seconds under typical device conditions.
- **NFR-004**: Secrets MUST be provided via env/`--dart-define`; no hardcoded keys or debug-only toggles in production.
- **NFR-005**: App Store purpose strings/privacy details MUST be captured for camera and photo library access.
- **NFR-006**: Crash reporting MUST be enabled with PII-safe metadata; photo content MUST NOT be logged.
- **NFR-007**: Analytics MUST be minimal and logging MUST avoid PII; photo content MUST NOT be tracked.
- **NFR-008**: Feature flags/kill-switches MUST exist for photo capture/attachment flows.
- **NFR-009**: AI calls MUST go through a server proxy; no client secrets.

### Key Entities *(include if feature involves data)*

- **Ingredient**: A pantry item that can contain up to three associated photos.
- **Ingredient Photo**: A stored image linked to a specific ingredient, including display order and a local reference.

## Assumptions

- Photos are stored locally and are not synced to a cloud service in this phase.
- Users can view existing photos without re-granting permissions after they are saved.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can add an ingredient with photos in under 2 minutes in 95% of attempts.
- **SC-002**: 95% of photo attachments are successfully restored after app restart.
- **SC-003**: 90% of users can open a full-size photo on the first try without errors.
- **SC-004**: Support requests related to missing ingredient photos decrease by 50% within one release cycle.
