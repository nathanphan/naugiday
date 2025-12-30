# Quickstart: Add Ingredient Photos

## Local Setup

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. `flutter test`

## Manual Verification Scenarios

- Add ingredient with 1-3 photos from gallery and save; confirm thumbnails persist after restart.
- Add ingredient with camera photo; confirm thumbnail renders and full-size view opens.
- Attempt to add a 4th photo; verify limit messaging and save remains valid.
- Edit an ingredient to delete a photo; confirm it disappears after save and restart.
- Deny photo permissions; verify error state and guidance to settings.
- Increase text size (iOS Accessibility) and confirm photo labels/buttons are readable and not clipped.

## Performance Check

- Scroll ingredient list with thumbnails and confirm no jank; target p95 frame time <=16ms.

## Migration Notes

- New ingredient records include a photo list; older records default to an empty list.
- If migration issues are detected, clear invalid photo references and re-save the ingredient.

## Compliance Checks

- Confirm crash reporting is initialized and does not log photo paths.
- Verify no new secrets or hardcoded keys were added for photo capture/selection.
- Ensure no AI calls are introduced in photo flows.
- Review telemetry events to confirm they do not include photo paths or PII.
