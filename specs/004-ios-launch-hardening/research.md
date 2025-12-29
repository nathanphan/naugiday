# Research — Day-1 Launch Hardening (iOS)

## Decisions

- **Remote kill switches**  
  - **Decision**: Fetch AI/image feature flags from the existing server proxy
    via a small JSON config endpoint and cache locally for offline use.  
  - **Rationale**: Enables post-release disablement without a new build while
    keeping client secrets out of the app.  
  - **Alternatives considered**: Build-time flags (too slow), local-only toggles
    (cannot mitigate live issues).

- **Minimal analytics scope**  
  - **Decision**: Record only `screen_view` plus three CTA events
    (scan ingredients, save recipe, generate recipe) with no PII.  
  - **Rationale**: Satisfies day-1 observability with minimal privacy risk.  
  - **Alternatives considered**: All CTAs (higher noise/PII risk), screen_view
    only (insufficient funnel insight).

- **Logging default**  
  - **Decision**: Disable logs by default; enable for internal diagnostics only.  
  - **Rationale**: Prevents accidental PII capture in production.  
  - **Alternatives considered**: Always-on redacted logging (higher risk),
    crash-only logging (insufficient for diagnostics).

- **Performance budget**  
  - **Decision**: 60fps target with 95% of frames ≤16ms in primary flows.  
  - **Rationale**: Aligns with iOS UI expectations and the constitution.  
  - **Alternatives considered**: 55fps target (lower quality), qualitative-only
    budget (hard to verify).

- **Rollback plan focus**  
  - **Decision**: Rollback plan prioritizes remotely disabling AI and image
    features while preserving core recipe flows.  
  - **Rationale**: Minimizes user impact and avoids full release rollback.  
  - **Alternatives considered**: Full rollback (slower, higher risk).
