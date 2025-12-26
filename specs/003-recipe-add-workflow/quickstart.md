# Quickstart: Recipe Add Workflow with Ingredients, Steps, and Images

## Goal
Validate the add-recipe flow with ingredients, ordered steps, and locally stored images, all available offline.

## Setup
1) Ensure Flutter toolchain is installed and project dependencies are fetched (`flutter pub get`).
2) Run codegen if models/providers change: `flutter pub run build_runner build --delete-conflicting-outputs`.
3) Prepare a simulator/emulator or device with photo library/camera permissions available.

## How to Test the Flow
1) Launch the app and navigate to Add Recipe.
2) Enter a title and add at least three ingredients with quantities.
3) Add at least one cooking step; reorder to confirm ordering persists.
4) Attach up to two images from the device; confirm previews appear.
5) Save the recipe; restart the app (airplane mode) and reopen the recipe from the list.
6) Verify title, ingredients, step order, and images load offline.
7) Try deleting or editing an ingredient/step before save and confirm changes persist.
8) Deny photo permission and attempt to add an image; ensure a clear message appears and recipe can still be saved without images.

## Suggested Checks
- Validation prevents saving when title missing or ingredient list empty.
- Quantities must be positive numbers; zero/negative blocked.
- Image cap (5) enforced with warning; large files (>5MB) blocked with message.
- UI remains responsive during image selection and save; no visible jank.
- No crashes when backing out mid-image-pick or during async save (dispose-safe).

## Commands
- Run tests: `flutter test`
- Targeted add flow tests: `flutter test test/widget/add_recipe_steps_test.dart test/widget/add_recipe_images_test.dart test/integration/add_recipe_offline_test.dart`
- Format/lint (if configured): `flutter format .` and `flutter analyze`
- Regenerate code (when data/provider models change): `flutter pub run build_runner build --delete-conflicting-outputs`
