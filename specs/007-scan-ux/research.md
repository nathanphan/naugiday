# Research: Scan UX States

## Decision 1: Capture and gallery sources

- **Decision**: Keep `camera` for capture and use `image_picker` for gallery selection, with capture resolution set to `ResolutionPreset.medium` and gallery pick limited via `maxWidth`, `maxHeight`, and `imageQuality`.
- **Rationale**: Both packages already exist in the project, minimize new dependencies, and provide size control to meet large-image handling requirements.
- **Alternatives considered**: Replace capture with `image_picker` camera mode (less control), add a custom camera stack (higher complexity).

## Decision 2: Permission states and Settings deep link

- **Decision**: Add `permission_handler` to detect camera/photo permission states and open iOS Settings when denied; fall back to camera initialization errors where necessary.
- **Rationale**: Provides explicit permission states for UI variants and a reliable path to Settings for iOS.
- **Alternatives considered**: Use platform channels or `url_launcher` for settings (more custom work, less consistent permission checks).

## Decision 3: Offline queue persistence

- **Decision**: Persist scan queue metadata in a Hive box and store image files in app documents/cache, with a queued/processing/failed status and retry count.
- **Rationale**: Aligns with the offline-first architecture and existing Hive usage; keeps local files as the source of truth.
- **Alternatives considered**: Store binary blobs in Hive (larger box size), defer until backend exists (breaks offline requirement).

## Decision 4: Telemetry events

- **Decision**: Use the existing `TelemetryRepository` to record the specified scan events and expand the allowed event list to include scan UX events.
- **Rationale**: Reuses existing minimal analytics pipeline with offline queue behavior and avoids PII.
- **Alternatives considered**: Add a new analytics provider (unnecessary for minimal events).

## Decision 5: UI alignment with design assets

- **Decision**: Match the layouts and component styling to the `design/scan_screen` assets using Material 3 components and theme color scheme.
- **Rationale**: Ensures visual consistency with the approved designs while keeping platform consistency.
- **Alternatives considered**: Custom widget stack with hardcoded colors (violates UI constraints).
