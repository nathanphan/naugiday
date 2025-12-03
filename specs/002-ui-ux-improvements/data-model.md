# Data Model — UI/UX Improvements

## Entities

- **RecipePresentationState**
  - Fields: `heroTag` (String), `skeletonShape` (enum: card/list/header/steps), `shimmerEnabled` (bool), `entranceAnimation` (enum: fade/slide/scale), `ctaStates` (busy/idle/disabled), `favorite` (bool), `saved` (bool).
  - Notes: Pure presentation; derives from existing Recipe entities; no persistence changes.

- **DebugToggle**
  - Fields: `suggestionsMode` (enum: normal/loading/error/empty), `storageMode` (enum: normal/error/empty), `cameraMode` (enum: normal/unavailable/slowInit), `seedSamples` (bool).
  - Notes: Guarded by debug-only panel and/or `kDebugMode`; must not affect production builds.

- **IngredientLabel**
  - Fields: `imageId` (String), `label` (String), `edited` (bool).
  - Relationships: Attached to captured images; forwarded to detected ingredients banner in Suggestions; remains editable.

## State Transitions

- RecipePresentationState: `idle → loading (skeleton+shimmer) → data (animated entrance)`; `data → error/empty (illustrated card with CTAs)`; `ctaStates busy → idle` for generate/save/share.
- DebugToggle: switches override provider outputs in debug-only scope; reset to normal in production.
- IngredientLabel: `unlabeled → edited → propagated to suggestions`; edits can be repeated without loss.
