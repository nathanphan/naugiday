# Data Model — Persistent Local Recipe Storage

## Entities

### Recipe
- **Fields**: `id` (string/uuid), `title` (string), `description` (string, optional), `ingredients` (list<Ingredient>), `steps` (list<string>), `notes` (string, optional), `nutrition` (Nutrition, optional), `createdAt` (timestamp), `updatedAt` (timestamp), `source` (enum: user, ai)
- **Rules**: Title required; at least one ingredient; steps must preserve order; `id` unique; timestamps updated on save/edit.
- **Relationships**: Aggregates Ingredients and Nutrition.

### Ingredient
- **Fields**: `name` (string), `quantity` (string), `isOptional` (bool, optional)
- **Rules**: Name required; quantity captured as user-entered text to avoid loss of intent.
- **Relationships**: Belongs to a Recipe.

### Nutrition
- **Fields**: `calories` (int, optional), `protein` (int, optional), `carbs` (int, optional), `fat` (int, optional)
- **Rules**: Fields optional; default to null rather than zero when unknown to avoid misleading users.
- **Relationships**: Belongs to a Recipe.

## State and Persistence Notes
- Recipe saves must be atomic: either fully written or rolled back with a user-facing retry path.
- Schema evolution: new fields append with stable indices; unknown fields ignored safely.
- Navigation: back/home control from recipe detail must not discard unsaved changes; confirm or auto-save before leaving when edits exist.
