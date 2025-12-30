# Research: Add Ingredient Photos

## Decision: Use `image_picker` for gallery selection and camera capture

**Rationale**: It provides a consistent iOS photo library picker and camera capture flow with minimal integration work and fits the existing dependency constraints.
**Alternatives considered**: Camera-only capture (no gallery); custom platform channels for Photos UI.

## Decision: Store photo files in app documents and persist references in Hive

**Rationale**: Keeps attachments offline-first, reliable across restarts, and aligns with existing persistence practices for local assets.
**Alternatives considered**: Store raw image bytes in Hive; store in cache-only directories (risk of eviction).

## Decision: Enforce 3-photo limit in both UI and domain validation

**Rationale**: Prevents inconsistent states and ensures clear user feedback when the limit is reached.
**Alternatives considered**: UI-only enforcement (risk of bypass via state changes).

## Decision: Full-size viewer uses an in-app modal with swipe and zoom

**Rationale**: Provides a clear, accessible viewing experience without adding new dependencies; supports close-by-tap and gesture zoom.
**Alternatives considered**: Separate full-screen route without zoom; third-party gallery packages.

## Decision: Handle permissions with user guidance and retry path

**Rationale**: Denials are common and must not block core flows; users should be guided to settings when needed.
**Alternatives considered**: Silent failure or blocking save actions.

## Performance Note

- Target p95 frame time <=16ms; photo thumbnails should use resized decoding (cacheWidth/cacheHeight) to avoid jank on lists.
