# Data Model: Ingredient Management

## Entities

### Ingredient
**Purpose**: Represents a pantry item tracked by the user.

**Fields**:
- id: unique, stable identifier
- name: required, non-empty
- categoryId: required reference to Category
- categoryName: cached display name (optional)
- quantity: required numeric value, must be > 0
- unit: required (e.g., g, ml, pcs)
- expiryDate: optional; if present must be today or later
- freshnessOverride: optional manual toggle used only when no expiryDate
- freshnessStatus: derived (from expiryDate if present, else from freshnessOverride)
- inventoryState: enum (inStock, used, bought)
- lastUpdatedAt: timestamp
- createdAt: timestamp

**Validation Rules**:
- name is required
- categoryId must reference an existing category
- quantity must be numeric and > 0
- expiryDate, if provided, cannot be in the past
- duplicates are allowed but trigger a warning on save

**State Transitions**:
- On create: inventoryState defaults to inStock
- On edit: update fields, refresh lastUpdatedAt
- On bulk mark used/bought: update inventoryState only
- On bulk quantity update: set or adjust quantity within valid range

### Category
**Purpose**: Groups ingredients for filtering and organization.

**Fields**:
- id: unique identifier
- name: required, display label
- isCustom: boolean flag for user-added categories
- createdAt: timestamp

**Validation Rules**:
- name is required
- names should be unique (case-insensitive) to avoid duplicate categories

### BulkAction (command, not persisted)
**Purpose**: Represents a batch update applied to multiple ingredients.

**Fields**:
- ingredientIds: list of target ingredient IDs
- quantityMode: enum (set, adjust, none)
- quantityValue: numeric (required when quantityMode is set or adjust)
- status: enum (used, bought, none)
- appliedAt: timestamp

### UsageEvent (minimal analytics)
**Purpose**: Tracks add/edit/delete activity without personal data.

**Fields**:
- eventType: enum (add, edit, delete)
- ingredientId: identifier (non-PII)
- occurredAt: timestamp

## Relationships

- Category 1..* Ingredient
- BulkAction targets many Ingredients
- UsageEvent references a single Ingredient
