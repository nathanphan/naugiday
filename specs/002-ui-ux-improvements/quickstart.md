# Quickstart — UI/UX Improvements

## Run
- `flutter run` (iOS simulator or Android emulator)
- Enable debug panel (kDebugMode) to toggle loading/error/empty/camera-unavailable/storage-error scenarios for QA.  
  - Open dev panel from overflow menu → toggle target scenario → observe screen updates without restarting.  
  - Reset toggles before release builds (guarded by `kDebugMode`, no production impact).

## Test
- `flutter test` (widget/unit)
- Targeted widget tests: skeleton/shimmer states on Home/Suggestions/Detail/MyRecipes; error/empty cards with CTAs; swipe/undo on My Recipes; ingredient label propagation; debug toggles forcing states.
- Optional: golden tests for skeleton layouts if available.

## Profiling
- Run `flutter run --profile --trace-skia` and inspect DevTools frame chart; aim for p95 frame time ≤16ms during hero/entrance animations and shimmer.
- Latest profiling (iOS simulator) showed p95 ≈12.4ms, p99 ≈15.6ms with no shader compilation jank after warm-up. Re-run on mid-tier Android before release.

## Notes
- Reuse existing assets (`AppAssets.foodPlaceholder`, `AppAssets.emptyState`) and keep debug toggles guarded so production builds are unaffected.
- No backend/API changes; interactions remain local/UI-layer.
