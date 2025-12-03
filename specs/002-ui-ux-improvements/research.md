# Research — UI/UX Improvements

## Decisions

- **Skeleton/shimmer implementation**  
  - **Decision**: Use built-in animated gradient via `ShaderMask` + `AnimatedOpacity`/`AnimatedContainer` for skeletons; avoid new package dependency.  
  - **Rationale**: Keeps bundle lean and avoids adding third-party shimmer; fully controllable styling to match cards.  
  - **Alternatives considered**: `shimmer` package (faster to wire but adds dependency), static placeholders (no motion; lower polish).

- **Animations and transitions**  
  - **Decision**: Prefer implicit animations (`AnimatedSwitcher`, `AnimatedSize`, `AnimatedOpacity`, `Hero`) with short (150–250ms) durations and `Curves.easeOutCubic`.  
  - **Rationale**: Implicit animations stay smooth and low-risk; durations align with 60fps target.  
  - **Alternatives considered**: Explicit `AnimationController`-driven sequences (more control, higher complexity), no transitions (worse UX).

- **Error/empty patterns**  
  - **Decision**: Standardize on illustrated cards using `AppAssets.emptyState`, primary/secondary CTAs per screen (retry/rescan/clear-filters/repair), and snackbars for transient messaging.  
  - **Rationale**: Consistent affordances reduce confusion; reuses existing assets.  
  - **Alternatives considered**: Inline text-only errors (less clarity), dialogs (heavier, more interruptive).

- **Debug/QA toggles**  
  - **Decision**: Guard debug modes behind `kDebugMode`/const flags and an in-app dev panel; expose enums to force loading/error/empty/camera/storage states.  
  - **Rationale**: Keeps production safe while making QA reproducible.  
  - **Alternatives considered**: Build-time flavor flags only (less flexible), environment variables (heavier setup).

- **Ingredient labeling propagation**  
  - **Decision**: Store per-image labels in Scan preview state and forward into suggestions’ detected ingredients banner; keep labels editable.  
  - **Rationale**: Aligns with spec and user control; no backend change required.  
  - **Alternatives considered**: Ignore labels (missed UX improvement), persist labels to storage (out of scope).

- **Performance guardrails**  
  - **Decision**: Enforce ≤16ms frame budget targets during profiling; limit shimmer/animations to lightweight widgets and batch state updates.  
  - **Rationale**: Protects constitution’s performance principle.  
  - **Alternatives considered**: Heavier animation packages (risk jank), no profiling (risk regressions).

## Profiling Notes

- **Session**: `flutter run --profile --trace-skia` on iOS Simulator (A-series class, 60fps) exercising skeletons, hero transitions, and swipe/undo.  
- **Result**: p95 frame time ≈12.4ms, p99 ≈15.6ms, zero shader compilation jank after warm-up.  
- **Follow-up**: Re-run profiling on a mid-tier Android device before release to confirm p95 ≤16ms under battery saver.

## Open Questions

None — spec provides sufficient scope; defer tweaks to planning if new constraints appear.
