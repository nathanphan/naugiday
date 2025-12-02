# UI/UX Improvements Specification

## Overview
To make NauGiDay feel like a premium application, we will implement several UI/UX enhancements focusing on feedback, transitions, and visual polish.

## Proposed Improvements

### 1. Loading States (Shimmer Effects)
- **Problem**: Simple `CircularProgressIndicator` is functional but basic.
- **Solution**: Implement "Skeleton" or "Shimmer" loading placeholders for:
    - Recipe cards in the Home screen.
    - The "Generating Recipes" state (which might take a few seconds with real AI).

### 2. Transitions & Animations
- **Hero Animations**: Smoothly transition the food image from the `RecipeCard` to the `RecipeDetailScreen`.
- **List Animations**: Animate list items appearing (e.g., slide in and fade) when recipes are loaded.
- **Button Feedback**: Add scale or color pulse animations on critical actions like "Scan" or "Generate".

### 3. Error Handling & Empty States
- **Custom Error Widgets**: Instead of red error text, use friendly illustrations (from our assets) with "Retry" buttons.
- **Toast/Snackbars**: Show success messages when a recipe is saved to "My Recipes".

### 4. Theming
- **Dark Mode**: Ensure all colors adapt correctly to system dark mode.
- **Typography**: Verify text hierarchy and readability across different screen sizes.

### 5. Interactive Elements
- **Swipe to Delete**: Implement dismissible list items in "My Recipes" with a confirmation background.
- **Ingredient Editing**: Allow users to tap and edit scanned ingredients before generating recipes (in case of OCR errors).
