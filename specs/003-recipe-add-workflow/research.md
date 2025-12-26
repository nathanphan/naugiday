# Research: Recipe Add Workflow with Ingredients, Steps, and Images

## Decisions

- **Local persistence stays on Hive with recipe DTOs and image references.**  
  **Rationale**: Aligns with existing local storage and constitution offline-resilience principle; avoids new infra.  
  **Alternatives considered**: Drift/SQLite (heavier migration), in-memory only (breaks offline reopen).

- **Image storage is local file paths in app documents/cache with 5 images max and 5MB per image.**  
  **Rationale**: Prevents storage bloat, keeps UI responsive; limits match mobile constraints.  
  **Alternatives considered**: Base64 in Hive (bloats box), unlimited images (risk disk exhaustion), premature cloud upload (out of scope).

## Performance Notes

- Controller-based add/save for recipes (ingredients/steps/images) completes instantly in tests; no observed jank in test environment. Recheck on device if image attach uses large files.
- Image cap enforcement is synchronous in controller; repository copies images via ImageStorageService.
- Permission-denied and over-cap messaging surfaced immediately in controller tests; latency expected <2s once UI is wired to platform picker.

## Permissions Timing

- Permission-denied timing not yet measured in UI; should be <2s per success criteria when implemented with platform picker.

- **Validation rules: title required; ≥1 ingredient; ingredient name required; quantity must be positive numeric with optional free-text unit; steps optional but ordered if present.**  
  **Rationale**: Matches spec acceptance and ensures usable recipes.  
  **Alternatives considered**: Allow empty quantities (hurts usefulness), enforce unit taxonomy (adds scope).

- **Image permission flow: request once per session; on denial, surface error and continue save without images.**  
  **Rationale**: Preserves recipe creation flow and complies with constitution UX/performance principle.  
  **Alternatives considered**: Block save when denied (harms UX), silent failure (confusing).

- **Async safety: controllers check `ref.mounted` (or dispose callbacks) before updating state after async image pick or file write.**  
  **Rationale**: Avoids dispose-after-await errors per constitution quality gates.  
  **Alternatives considered**: Unchecked updates (risk runtime crashes).

## Open Items to Watch (no blockers)

- If future cloud sync adds remote IDs, ensure local image metadata captures file name, size, and added timestamp for reconciliation.
