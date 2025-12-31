# Feature Specification: Scan UX States

**Feature Branch**: `007-scan-ux`  
**Created**: 2025-12-30  
**Status**: Draft  
**Input**: User description: "Implement the full Scan feature UX for iOS in Flutter using Material 3, covering all scan_screen variants: normal_state, initializing_state, camera_unavailable, permission_denied, and disabled_state. In normal_state, support camera capture + gallery picker (complete the TODO) with clear primary CTAs, guidance text, and preview of the captured/selected image. In initializing_state, show a skeleton/loading UI while camera is preparing. In camera_unavailable, show a dedicated fallback UI with explanation and alternative path (gallery picker if allowed) + retry. In permission_denied, implement a first-class denied UI with steps to enable permission and a deep link to iOS Settings when possible; include a “Continue with gallery” fallback if applicable. In disabled_state, respect a feature flag/kill-switch to disable scanning and show a friendly explanation + alternative entry points (manual add ingredients / shopping list). Ensure robust error handling for capture/pick failures, large images (downsize/compress), and offline behavior (store locally and queue processing if needed). Use Material 3 components only (Scaffold, AppBar, Card, FilledButton/OutlinedButton, banners/snackbars), Theme.of(context).colorScheme (no hardcoded colors), consistent spacing (8/12/16/24), and accessibility (VoiceOver labels, tap targets). Add minimal analytics (scan_open, capture_photo, pick_gallery, permission_denied, open_settings, scan_retry, scan_disabled) and non-fatal error capture. Include widget + integration tests for permission denial flow, gallery picker flow, camera unavailable, and disabled-state toggling. Make sure that you look at folder design and look for all scan_screen folder. apply same UI"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Capture or Select an Image (Priority: P1)

As a user, I can open the scan screen and capture a photo or choose one from my gallery, see a clear preview, and proceed confidently.

**Why this priority**: This is the core value of scanning and the shortest path to usefulness.

**Independent Test**: Can be fully tested by opening scan, capturing or picking an image, and reaching the preview state without any other features.

**Acceptance Scenarios**:

1. **Given** the scan screen is available, **When** I capture a photo, **Then** I see a preview of the image with a clear next step.
2. **Given** the scan screen is available, **When** I choose an image from my gallery, **Then** I see a preview of the selected image with a clear next step.

---

### User Story 2 - Resolve Permission or Camera Issues (Priority: P2)

As a user, when camera access is unavailable or denied, I receive clear guidance, a way to retry, and an alternative path when possible.

**Why this priority**: Scanning fails without camera access; clear recovery reduces frustration and support burden.

**Independent Test**: Can be fully tested by simulating each unavailable state and confirming the correct guidance and fallback are shown.

**Acceptance Scenarios**:

1. **Given** the camera is initializing, **When** I open scan, **Then** I see a loading state until the camera is ready or a fallback is shown.
2. **Given** the camera is unavailable, **When** I open scan, **Then** I see an explanation, a retry action, and an alternative option if available.
3. **Given** camera permission is denied, **When** I open scan, **Then** I see steps to enable permission and a direct path to device settings when supported.

---

### User Story 3 - Recover from Errors and Offline Use (Priority: P3)

As a user, I can still capture or select images even when errors occur or I am offline, and the system safely keeps my image for later processing.

**Why this priority**: Reliability and offline support protect user trust and prevent data loss.

**Independent Test**: Can be fully tested by simulating capture or picker failures and offline mode, then verifying the image is saved and queued.

**Acceptance Scenarios**:

1. **Given** an image capture or selection fails, **When** I retry, **Then** I can attempt again without losing my context.
2. **Given** I am offline, **When** I capture or select an image, **Then** the image is stored locally and queued for later processing with a visible status.

---

### User Story 4 - Respect Feature Disablement (Priority: P4)

As a user, if scanning is disabled, I see a friendly explanation and clear alternative entry points to continue my task.

**Why this priority**: A clean fallback prevents dead ends when scanning is turned off for safety or rollout control.

**Independent Test**: Can be fully tested by toggling the scan disablement and confirming alternate entry points are available.

**Acceptance Scenarios**:

1. **Given** scanning is disabled, **When** I open scan, **Then** I see a friendly explanation and options to add ingredients manually or use the shopping list.

---

### Edge Cases

- What happens when the device does not support a camera at all?
- How does the system handle a user denying permission repeatedly and dismissing the guidance?
- What happens if the image is too large to process and size reduction fails?
- How does the system handle no gallery access or an empty gallery selection?
- What happens when storage is full and the image cannot be saved offline?
- How does the system behave if the feature is disabled while the user is already on the scan screen?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a scan screen that offers capture and gallery selection with clear primary actions and guidance.
- **FR-002**: System MUST display a preview of the captured or selected image before proceeding.
- **FR-003**: System MUST show an initializing state while the camera is preparing and switch to an actionable state or fallback when ready.
- **FR-004**: System MUST show a dedicated camera-unavailable state with an explanation, a retry action, and an alternate path when possible.
- **FR-005**: System MUST show a permission-denied state with steps to enable access and a direct path to device settings when supported.
- **FR-006**: System MUST allow a gallery-only fallback when camera access is denied or unavailable and gallery access is permitted.
- **FR-007**: System MUST allow scanning to be disabled via a feature flag and present alternative entry points to complete related tasks.
- **FR-008**: System MUST handle capture and picker failures with user-visible feedback and an immediate retry path.
- **FR-009**: System MUST handle large images by reducing size to a usable limit or clearly informing the user if it cannot proceed.
- **FR-010**: System MUST support offline usage by saving selected images locally and queueing them for later processing with visible status.
- **FR-011**: System MUST record minimal analytics for scan entry, capture, gallery selection, permission denial, settings access, retry, and disabled entry.
- **FR-012**: System MUST provide accessible labels and touch targets for all actions on the scan screen.

### Non-Functional Requirements (Constitution)

- **NFR-001**: Feature MUST work offline for core user flows with graceful
  degradation (capture or selection succeeds, processing is deferred, and the
  user sees a queued status).
- **NFR-002**: UI MUST include loading, empty, and error states and support dark
  mode + text scaling.
- **NFR-003**: Performance target MUST be defined: 95% of scan screen opens
  reach an interactive state in <=2 seconds with a 16ms frame budget target.
- **NFR-004**: Secrets MUST be provided via env/`--dart-define`; no hardcoded
  keys or debug-only toggles in production.
- **NFR-005**: App Store purpose strings/privacy details MUST be captured for
  any platform capability usage.
- **NFR-006**: Crash reporting MUST be enabled with PII-safe metadata.
- **NFR-007**: Analytics MUST be minimal and logging MUST avoid PII.
- **NFR-008**: Feature flags/kill-switches MUST exist for critical flows.
- **NFR-009**: AI calls MUST go through a server proxy; no client secrets.
- **NFR-010**: Scan interactions MUST remain usable with screen readers and 44pt+ tap targets.

### Key Entities *(include if feature involves data)*

- **Scan Session**: A user visit to the scan screen, including state (normal, initializing, unavailable, denied, disabled) and timestamps.
- **Scan Image**: The captured or selected image, including source (camera or gallery), preview, and processing status.
- **Scan Queue Item**: A locally stored image awaiting processing, including offline status and retry count.
- **Permission State**: The current permission status for camera and gallery access.
- **Feature Flag**: A toggle that enables or disables scanning for all users or specific cohorts.

### Assumptions

- Scanning can proceed without immediate network access, and any processing can be deferred.
- The scan screen has access to at least one alternative path (gallery or manual entry) when camera use is unavailable.
- No new user roles or authentication changes are required for this feature.

### Dependencies

- Device camera and photo library capabilities are available on supported devices.
- The app can surface a direct path to device settings when permission is denied.
- Local storage is available for saving queued scan images.

### Out of Scope

- Image editing tools beyond preview and selection.
- Changes to backend recognition models or server-side processing logic.
- Multi-image batch scanning in a single scan session.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 95% of scan screen opens reach an interactive state in 2 seconds or less.
- **SC-002**: At least 90% of users who open scan successfully capture or select an image and reach preview on the first attempt.
- **SC-003**: For permission-denied cases, at least 80% of users either enable permission or complete a gallery fallback.
- **SC-004**: 99% of offline scan attempts are queued locally without data loss and can be resumed later.
