# Data Model: Add Ingredient Photos

## Entities

### Ingredient

- **id**: unique identifier
- **name**: display name
- **category**: storage category
- **quantity**: numeric amount
- **unit**: unit label
- **freshness/expiry**: optional expiry date
- **photoRefs**: ordered list of Ingredient Photo references (0-3)
- **createdAt**: timestamp
- **updatedAt**: timestamp

### Ingredient Photo

- **id**: unique identifier
- **ingredientId**: parent ingredient id
- **path**: local file path to the stored photo
- **source**: capture origin (camera or gallery)
- **displayOrder**: integer order for thumbnail rendering
- **createdAt**: timestamp

## Relationships

- Ingredient **has many** Ingredient Photo (0..3)
- Ingredient Photo **belongs to** Ingredient

## Validation Rules

- An ingredient MUST have at most 3 photoRefs.
- photoRefs MUST be unique and reference existing local files.
- displayOrder MUST be contiguous starting from 0.

## State Transitions

- Ingredient Photo can be added, reordered, or removed while editing an ingredient.
- Removing a photo deletes its reference and its local file.
