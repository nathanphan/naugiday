# Contracts: Recipe Add Workflow with Ingredients, Steps, and Images

No external API contracts are introduced in this phase. All functionality is local:
- Recipe persistence via Hive box (data-layer repository).
- Image attachments stored as local file paths referenced by recipes.

If/when cloud sync is added, define upload/list/delete contracts for recipe images and recipe payloads in a future spec/plan.
