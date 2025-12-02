# NauGiDay Development Roadmap

This document outlines the proposed next steps for the NauGiDay application, moving from the current MVP state to a fully functional and polished product.

## Phase 1: Real AI Integration
**Goal**: Replace the `FakeAiRecipeService` with a real Generative AI integration (e.g., Google Gemini API) to generate actual recipes based on scanned ingredients.
- **Spec File**: [ai_integration_spec.md](./ai_integration_spec.md)

## Phase 2: Robust Data Persistence
**Goal**: Ensure user-generated and saved recipes are stored persistently and efficiently using a local database solution (e.g., Hive or SQLite via Drift).
- **Spec File**: [persistence_spec.md](./persistence_spec.md)

## Phase 3: UI/UX Polish & Animations
**Goal**: Elevate the user experience with smooth transitions, loading states, error handling, and a more refined design system.
- **Spec File**: [ui_ux_improvements_spec.md](./ui_ux_improvements_spec.md)

## Phase 4: Testing & Quality Assurance
**Goal**: Implement a comprehensive test suite including unit tests for repositories/providers and widget tests for critical screens.
- **Spec File**: [testing_strategy_spec.md](./testing_strategy_spec.md)
