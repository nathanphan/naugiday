# Quickstart: Day-1 Launch Hardening (iOS)

## Goal
Validate App Store compliance, telemetry safety, kill switches, accessibility,
and performance budgets for first submission.

## Setup
1) Ensure Flutter toolchain is installed and project dependencies are fetched
   (`flutter pub get`).
2) Run codegen if models/providers change:
   `dart run build_runner build --delete-conflicting-outputs`.
3) Prepare an iOS device or simulator with camera/photos permissions available.

## How to Test the Flow
1) Open the release checklist screen and confirm purpose strings, privacy policy
   URL, and App Privacy details are recorded as complete.
2) Trigger a controlled crash (non-production build) and confirm crash reporting
   receives the event without PII.
3) Navigate all primary screens and trigger the three CTAs (scan ingredients,
   save recipe, generate recipe); confirm only those events are recorded.
4) Toggle remote kill switches for AI and image features; verify the UI blocks
   those actions with a clear message while core recipe flows still work.
5) Enable VoiceOver and traverse primary flows; confirm labels are meaningful.
6) Verify tap targets meet iOS accessibility sizing on primary screens.
7) Run the performance checklist; confirm 60fps target with 95% of frames
   <=16ms in primary flows.
8) Validate the rollback plan: confirm steps prioritize remote disablement of AI
   and image features.

## Suggested Checks
- Denied camera/photo permissions produce clear guidance and no crashes.
- Offline mode uses cached feature flags and preserves core flows.
- Logging remains disabled by default; diagnostics require internal enablement.
- Release checklist is complete and exportable for App Store review notes.
- Performance checklist completed and signed off.

## Commands
- Run tests: `flutter test`
- Run analyzer: `flutter analyze`
- Build iOS release (if needed): `flutter build ios --release`
