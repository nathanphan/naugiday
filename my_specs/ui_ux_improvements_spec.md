# UI/UX Improvements Specification

## Context Snapshot
- App uses Material 3 with seeded palettes in `lib/presentation/theme/app_theme.dart` and go_router shell navigation in `lib/presentation/router/app_router.dart` (bottom bar in `MainScaffold`).
- Key screens/widgets: `HomeScreen` (meal selector, `HomeCTACard`, `QuickActionsRow`, `SuggestedRecipeCard`), `ScanScreen` with `CameraControlsOverlay` + `ScanPreviewSheet`, `RecipeSuggestionsScreen` (search + `FilterChip` + `RecipeCard` grid), `RecipeDetailScreen` (food placeholder with owned/missing ingredient split), `MyRecipesScreen` (list + skeleton + `AppAssets.emptyState`).
- Assets available: `AppAssets.foodPlaceholder`, `AppAssets.appIcon`, `AppAssets.emptyState`.

## Prioritized Improvements
### Loading, Feedback, and Status
- Replace spinner-only states with skeletons/shimmer matching current layouts:
  - `RecipeSuggestionsScreen.loading` → grid skeleton shaped like `RecipeCard` (2-column, 0.75 aspect); use `shimmer` package or animated gradient.
  - `HomeScreen` `SuggestedRecipeCard` row and `RecipeDetailScreen` header/steps → lightweight skeletons for first paint.
  - Refresh `MyRecipesScreen` skeleton with subtle shimmer while keeping the existing structure.
- Camera/AI flow:
  - `ScanScreen` initialization → gradient backdrop with progress copy instead of plain loader; fallback illustration when camera unavailable.
  - `ScanPreviewSheet` “Generate Recipes” button shows busy/disabled state while `suggestionsProvider` is loading; optional per-image upload tick if/when backend is added.
  - Surface AI fetch errors via `SnackBar` with retry in `RecipeSuggestionsScreen`; toast on successful save/update/delete via `recipeController`.

### Motion and Transitions
- Hero from `RecipeCard`/`AppAssets.foodPlaceholder` to `RecipeDetailScreen` header using `Hero(tag: recipe.id, ...)`, including hero-aware AppBar collapse.
- List/grid entrance: use `AnimatedSwitcher`/implicit list animations for `RecipeSuggestionsScreen` grid and `MyRecipesScreen` so items slide+fade on load/filter; animate `FilterChip` selection (color/scale).
- Smooth sheet/CTA interactions: `AnimatedSize` on `ScanPreviewSheet` height changes, subtle scale/ink feedback on `HomeCTACard` and `QuickActionsRow` icons.

### Error and Empty States
- Standardize illustrated empty/error widgets using `AppAssets.emptyState` + primary/secondary CTAs:
  - `RecipeSuggestionsScreen`: empty (filters/search) → “Clear filters” + “Rescan” actions; error → friendly copy + retry.
  - `ScanScreen` camera failure → prompt to open settings + retry.
  - `MyRecipesScreen` error (`RecipeStorageException`) → keep repair/retry actions but wrap in illustrated card.
- Missing ingredients on `RecipeDetailScreen`: CTA to “Add missing items to shopping list” (routes to `/shopping-list`; stub acceptable until list exists).

### Theming and Readability
- Extend `AppTheme` typography to cover label/body small weights and consistent letter spacing; ensure `NavigationBar`/bottom sheets share surface tint for dark mode.
- Define spacing/radius tokens and reuse on `RecipeCard`, `SuggestedRecipeCard`, and `ScanPreviewSheet` to keep corner/shadow consistency.
- Audit chip/pill contrast (`FilterChip`, `SegmentedButton`) for dark mode; ensure text/icons meet contrast targets.

### Interaction Enhancements
- Ingredient editing before generation: in `ScanPreviewSheet` allow labeling each captured image (text input or quick tag). Forward labels with `imagePaths` into the suggestions request so `RecipeSuggestionsScreen` “Detected Ingredients” banner uses edited values and remains editable.
- `MyRecipesScreen`: adopt `Dismissible` rows with confirm + undo snackbar; long-press to favorite/pin; keep Riverpod refresh hook.
- `RecipeDetailScreen`: add floating “Save/Unsave” and “Share” actions (share copies ingredients+steps).

## Acceptance
- Animations remain smooth (<=16ms frame budget; prefer implicit animations).
- All new states honor light/dark themes and existing assets; navigation contracts in `lib/presentation/router/app_router.dart` stay intact.
- Each loading/error/empty state is reproducible via dev toggles or QA hooks.

## QA Hooks (make states reproducible)
- `suggestionsProvider`: expose a debug flag (e.g., `SuggestionsDebugMode { loading, error, empty }`) to force spinner, throw, or return empty list; toggle via in-app dev menu or const bool.
- `ScanScreen`: add a debug switch to simulate camera unavailable and to force slow init; expose a dummy image list to preview `ScanPreviewSheet` without capturing.
- `RecipeController`/`MyRecipesScreen`: add a dev flag to return `RecipeStorageException` and an empty list; add an option to seed sample recipes for animation tests.
- `RecipeDetailScreen`: allow injecting `missingIngredients` and toggling “saved” state to verify new CTAs/hero.
- Ensure toggles are compile-time or guarded by debug-only menu so production builds remain unaffected.
