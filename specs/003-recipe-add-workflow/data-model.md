# Data Model: Recipe Add Workflow with Ingredients, Steps, and Images

## Entities

### Recipe
- id (string/UUID)
- title (string, required)
- description (string, optional)
- ingredients (list<Ingredient>, required, min 1)
- steps (list<CookingStep>, optional but ordered)
- images (list<RecipeImage>, optional, max 5)
- createdAt (DateTime)
- updatedAt (DateTime)
- offlineAvailable (bool)

Validation:
- title non-empty
- ingredients length >= 1
- each ingredient passes its validation
- steps keep stable order; no duplicate positions
- images count <= 5; each image passes validation

### Ingredient
- id (string/UUID)
- name (string, required)
- quantityValue (double, required, > 0)
- quantityUnit (string, optional/free text)
- notes (string, optional)

Validation:
- name non-empty
- quantityValue > 0

### CookingStep
- id (string/UUID)
- position (int, required, >= 1, unique within recipe)
- instruction (string, required)

Validation:
- instruction non-empty
- positions contiguous/unique to preserve order

### RecipeImage
- id (string/UUID)
- localPath (string, required)
- fileName (string, required)
- fileSizeBytes (int, required, > 0, <= 5MB)
- addedAt (DateTime)

Validation:
- localPath non-empty, file exists when saved
- fileSizeBytes within limit

## Relationships
- Recipe 1 - many Ingredient
- Recipe 1 - many CookingStep
- Recipe 1 - many RecipeImage
- Positions order steps; image list order preserved as added
