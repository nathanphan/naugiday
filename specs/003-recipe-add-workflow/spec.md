# Feature Specification: Recipe Add Workflow with Ingredients, Steps, and Images

**Feature Branch**: `003-recipe-add-workflow`  
**Created**: 2025-12-04  
**Status**: Draft  
**Input**: User description: "as a user I want my recipe adding page to have ingredient where I can add ingredient with its quanlity. Next adding recipe page, I need a place to fill in steps to cook my meal. I want to have ability to add images. Those images now will be saved at local first, then in later phase those images will be synced to cloud (s3 or google cloud). ultra think and must provide a practical, usuable spec"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Add recipe with ingredients (Priority: P1)

As a cook, I can create a recipe by entering a title and multiple ingredients with names and quantities so I can save a complete list of what I need.

**Why this priority**: Without ingredients, a recipe is unusable; this is the core value for capturing shopping and cooking needs.

**Independent Test**: User can open the add-recipe page, add at least three ingredients with quantities, save, close the app, reopen, and see the recipe and ingredients intact offline.

**Acceptance Scenarios**:

1. **Given** the add-recipe form is empty, **When** the user adds an ingredient name and quantity and saves the recipe, **Then** the recipe is stored with that ingredient and shows on subsequent opens.
2. **Given** multiple ingredients have been added, **When** the user edits or removes one before saving, **Then** the saved recipe reflects the edited list accurately.

---

### User Story 2 - Add cooking steps (Priority: P2)

As a cook, I can enter ordered cooking steps for a recipe so I can follow the sequence while preparing the meal.

**Why this priority**: Steps make the recipe actionable after ingredients exist.

**Independent Test**: User can add at least three ordered steps, save the recipe, reopen, and see the exact step order offline.

**Acceptance Scenarios**:

1. **Given** a recipe draft with ingredients, **When** the user adds steps with ordered positions and saves, **Then** the saved recipe retains the order and content of all steps.

---

### User Story 3 - Attach images locally (Priority: P3)

As a cook, I can attach photos to my recipe that are stored locally so I can view them offline; future cloud sync will be handled in a later phase.

**Why this priority**: Images enhance clarity but are optional after ingredients and steps.

**Independent Test**: User can attach at least two images to a recipe, save, restart the app, and view the images without network connectivity.

**Acceptance Scenarios**:

1. **Given** device photo access is granted, **When** the user attaches images to the recipe and saves, **Then** the recipe displays the images offline and associates them with the correct recipe.
2. **Given** device photo access is denied, **When** the user attempts to add an image, **Then** the user is informed and can continue saving the recipe without images.

---

### Edge Cases

- Ingredient without quantity should be blocked or flagged before save; quantity of zero or negative is rejected.
- Recipe cannot be saved without a title and at least one ingredient.
- Step list may be empty for draft save but must preserve order if present; reordering should not duplicate or drop steps.
- Large images or many images must either be bounded by a reasonable limit (see assumptions) or clearly warn the user.
- Permission denied or revoked for photos should surface a clear message and keep the recipe content intact without images.
- Offline mode must still allow creating and reopening recipes with ingredients/steps/images stored locally.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST allow users to add, edit, and delete multiple ingredients, each with a name and quantity, within the add-recipe flow.
- **FR-002**: The system MUST require a recipe title and at least one ingredient before allowing final save.
- **FR-003**: The system MUST persist recipe data (title, ingredients with quantities, steps, and any images) locally so it is available after app restart and offline.
- **FR-004**: The system MUST allow users to add, reorder, edit, and delete cooking steps while maintaining their order on save and reload.
- **FR-005**: The system MUST allow users to attach one or more images to a recipe and store them locally with references to the recipe for offline viewing.
- **FR-006**: The system MUST handle photo permissions gracefully, informing the user when access is denied and allowing recipe save without images.
- **FR-007**: The system MUST prevent saving ingredients with empty names or invalid quantities (zero, negative, or non-numeric where numeric quantities are required).
- **FR-008**: The system SHOULD cap per-recipe image attachments and total recipe size to avoid storage bloat, communicating limits to the user when reached.
- **FR-009**: The system SHOULD prepare for future cloud sync by keeping image references and metadata structured for later upload without changing local storage behavior in this phase.

### Key Entities *(include if feature involves data)*

- **Recipe**: Title, optional description/notes, list of ingredients, ordered steps, image references, creation/update timestamps, offline availability flag.
- **Ingredient**: Name, quantity (numeric value plus optional unit), optional notes; belongs to one recipe.
- **CookingStep**: Ordered instruction text; belongs to one recipe with a position index.
- **RecipeImage**: Local URI/reference and metadata (e.g., file name, size, added time); belongs to one recipe.

### Assumptions

- Per-recipe image limit is 5 images and individual image size is capped at 5MB; UI warns before hitting the cap and blocks oversize files.
- Numeric quantity entry is required for shopping clarity; units may be free text to avoid over-constraining users.
- Cloud sync is explicitly out of scope for this phase; only local storage and retrieval are required.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 95% of users can create and save a recipe with at least three ingredients and one step in under 2 minutes without errors.
- **SC-002**: 95% of saved recipes reopen offline with all ingredients, quantities, steps, and attached images intact after an app restart.
- **SC-003**: At least 90% of image attachment attempts succeed when permissions are granted; permission-denied flows inform users within 2 seconds and allow save without images.
- **SC-004**: Storage usage per recipe remains under the defined limits, and users are warned before limits are exceeded in 100% of attempts to add beyond the cap.
