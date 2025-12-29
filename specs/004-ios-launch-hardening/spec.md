# Feature Specification: Day-1 Launch Hardening (iOS)

**Feature Branch**: `004-ios-launch-hardening`  
**Created**: 2025-12-28  
**Status**: Draft  
**Input**: User description: "Day-1 Launch Hardening for iOS. Add App Store compliance (Info.plist purpose strings for Photos/Camera, privacy policy URL, App Privacy details), crash reporting, minimal analytics (screen_view + key CTAs), PII-safe logging, feature flags/kill-switches (disable AI + images), accessibility pass (VoiceOver labels, tap targets), performance budgets checklist, and a release checklist + rollback plan. Keep it simple and shippable for first submission."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Submission-Ready Compliance (Priority: P1)

As a release owner, I need the iOS submission materials and in-app disclosures to
be complete and accurate so the first App Store review can proceed without
blocking issues.

**Why this priority**: Without compliance artifacts and a release checklist, the
app cannot ship.

**Independent Test**: A reviewer can verify all required disclosure fields,
purpose strings, and the release checklist in a single review session.

**Acceptance Scenarios**:

1. **Given** a release candidate, **When** the compliance checklist is run,
   **Then** all required purpose strings, privacy policy URL, and App Privacy
   details are present and accurate.
2. **Given** a release candidate, **When** the release checklist is reviewed,
   **Then** a rollback plan exists and is clear enough to execute without
   engineering support.

---

### User Story 2 - Operational Safety Controls (Priority: P2)

As a release owner, I need safe controls for telemetry and risky features so we
can reduce risk without blocking core cooking flows.

**Why this priority**: Crash reporting, minimal analytics, and kill switches are
critical for monitoring and rapid mitigation after release.

**Independent Test**: A tester can toggle kill switches and verify AI and image
features are disabled while core recipe browsing/saving still works, and can
confirm only the minimal analytics events are recorded.

**Acceptance Scenarios**:

1. **Given** the AI feature is disabled, **When** a user attempts AI actions,
   **Then** the UI communicates the feature is unavailable and core recipe
   features still function.
2. **Given** image features are disabled, **When** a user attempts image actions,
   **Then** the UI communicates the feature is unavailable and core recipe
   features still function.

---

### User Story 3 - Accessible and Responsive Experience (Priority: P3)

As a user relying on accessibility tools, I need the core app flows to be
navigable with clear labels and comfortable tap targets, and to remain responsive
in normal use.

**Why this priority**: Accessibility and performance are required for review and
for a reliable first impression.

**Independent Test**: A tester can complete primary flows with VoiceOver and can
validate tap targets and performance against the defined budget checklist.

**Acceptance Scenarios**:

1. **Given** VoiceOver is enabled, **When** the user navigates the primary flows,
   **Then** all actionable elements have meaningful labels and are discoverable.
2. **Given** the performance checklist is applied to a release candidate,
   **When** the primary flows are exercised, **Then** performance stays within
   the stated budget.

---

### Edge Cases

- What happens when camera or photo permissions are denied?
- How does the system behave when analytics are disabled or unavailable?
- What happens if a kill switch is toggled while a user is in an AI or image
  flow?
- How does the app behave when the device is offline during core flows?

## Clarifications

### Session 2025-12-28

- Q: How should kill-switches be configured? → A: Remote-configurable kill
  switches (can change after release).
- Q: What is the default logging mode for day-1? → A: Disabled by default;
  enable only for internal diagnostics.
- Q: What performance budget should be used for primary flows? → A: 60fps
  target; 95% of frames ≤16ms.
- Q: Which minimal analytics events should be captured? → A: `screen_view` plus
  scan ingredients, save recipe, and generate recipe.
- Q: What should the rollback plan prioritize? → A: Disable AI and image
  features remotely.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST include iOS purpose strings for camera and photo
  access that match actual usage.
- **FR-002**: The submission materials MUST include a privacy policy URL that is
  accessible to users.
- **FR-003**: The submission materials MUST include accurate App Privacy details
  describing data collection and usage.
- **FR-004**: The release package MUST include a release checklist and rollback
  plan that can be executed without engineering support, prioritizing remote
  disablement of AI and image features.
- **FR-005**: Crash reporting MUST be enabled for production releases with
  PII-safe metadata only.
- **FR-006**: Analytics MUST be limited to `screen_view` and the key CTAs:
  scan ingredients, save recipe, and generate recipe, with no PII.
- **FR-007**: Logging MUST be PII-safe and exclude user-entered content.
- **FR-007a**: Logging MUST be disabled by default and enabled only for
  internal diagnostics.
- **FR-008**: Feature flags/kill switches MUST be available to disable AI and
  image features independently while preserving core recipe flows. Kill
  switches MUST be remote-configurable after release.
- **FR-009**: Accessibility coverage MUST include VoiceOver labels for actionable
  elements and tap targets that meet iOS accessibility sizing.
- **FR-010**: A performance budgets checklist MUST exist and be applied to the
  release candidate before submission, with a 60fps target and 95% of frames
  at or below 16ms in primary flows.
- **FR-011**: When offline, the app MUST use cached feature flags and defer
  telemetry delivery without blocking core flows.
- **FR-012**: Release readiness MUST include CI checks for tests, lint,
  formatting, and an iOS release build.

### Non-Functional Requirements (Constitution)

- **NFR-001**: Feature MUST work offline for core user flows; specify any
  graceful-degradation behavior.
- **NFR-002**: UI MUST include loading, empty, and error states and support dark
  mode + text scaling.
- **NFR-003**: Performance target MUST be defined (e.g., p95 frame time ≤16ms).
- **NFR-004**: Secrets MUST be provided via env/`--dart-define`; no hardcoded
  keys or debug-only toggles in production.
- **NFR-005**: App Store purpose strings/privacy details MUST be captured for
  any platform capability usage.
- **NFR-006**: Crash reporting MUST be enabled with PII-safe metadata.
- **NFR-007**: Analytics MUST be minimal and logging MUST avoid PII.
- **NFR-008**: Feature flags/kill-switches MUST exist for critical flows.
- **NFR-009**: AI calls MUST go through a server proxy; no client secrets.

### Key Entities *(include if feature involves data)*

- **Privacy Disclosure Item**: A required purpose string, policy URL, or App
  Privacy disclosure and its status.
- **Telemetry Event**: A minimal analytics event captured for release health.
- **Feature Flag**: A switch that disables AI or image functionality.
- **Release Checklist Item**: A required release validation step and its status.
- **Rollback Plan Step**: A discrete action to mitigate a release issue.

## Assumptions

- iOS-only distribution is in scope for this release.
- Key CTAs include scan ingredients, save recipe, and generate recipe actions.
- Core recipe browsing and saving must remain available when AI or images are
  disabled.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of required App Store disclosure fields are completed and
  verified in the release checklist before submission.
- **SC-002**: Crash-free sessions are at or above 99% during internal release
  testing.
- **SC-003**: 100% of screens and key CTAs produce the agreed minimal analytics
  events with no PII.
- **SC-004**: Primary flows are fully operable with VoiceOver and tap targets
  meet iOS accessibility sizing on all primary screens.
- **SC-005**: Performance checklist shows primary flows meet the defined budget
  before submission.
