<!--
Sync Impact Report
Version change: 1.0.0 -> 1.0.1
Modified principles: Quality Gates & Targeted Tests (async lifecycle safety clarified)
Added sections: none
Removed sections: none
Templates requiring updates: ⚠ pending review (none applied)
Follow-up TODOs: TODO(RATIFICATION_DATE): original adoption date not provided
-->

# NauGiDay Constitution

## Core Principles

### Ingredient-Led Vietnamese Recipes
AI-generated and curated recipes MUST be grounded in the ingredients the user provides and stay within the Vietnamese cuisine focus unless explicitly labeled otherwise. Prompts and responses MUST favor structured JSON outputs that can be parsed deterministically. Recipes MUST avoid hallucinated ingredients, clearly separate optional pantry items, and call out allergen or safety notes when applicable.

### Layered Clean Architecture (Flutter + Riverpod)
The presentation layer (Flutter UI with Riverpod and GoRouter) MUST depend on domain contracts only; domain entities and use cases remain pure Dart with no Flutter or IO dependencies. The data layer owns integrations (Hive, AI clients) behind repositories. New dependencies are added at the lowest layer possible and injected upward. Code generation (Freezed, Hive adapters, Riverpod annotations) is kept current before merging.

### Local Data Ownership & Offline Resilience
User-authored recipes and scanned ingredients MUST persist locally (Hive or successor) and remain available offline. All flows MUST provide graceful degradation for missing network, AI failures, or camera limitations, including retries or manual entry paths. API keys and secrets MUST be supplied via environment configuration, never hardcoded or logged.

### Quality Gates & Targeted Tests
Critical flows (recipe list/detail, scan → generate, and persistence use cases) MUST have automated coverage: domain/use-case tests plus widget tests for primary screens. Build/format/lint and code generation MUST run clean before merge. Where new external integrations are added (e.g., Gemini), add contract or parsing tests to lock response formats.
Async state updates MUST guard disposed providers/controllers (e.g., check `ref.mounted` or cancel work) to avoid setState-after-dispose failures; long-running work must be cancellable on dispose.

### Performance, UX Polish, and Accessibility
The app MUST maintain smooth interactions (target 60fps) and provide clear feedback through loading skeletons, error states with retries, and purposeful animations. UI changes MUST respect dark mode and text scaling. Camera, image processing, and AI-triggered actions MUST avoid blocking the UI thread and surface progress to users.

## Security, Data Handling, and AI Use

Protect user content by storing recipes locally by default; if remote calls are required, transmit only the minimal data needed. Secrets (API keys, bundle IDs) live in env/define-time configuration and are never committed. AI prompts must avoid sending photos unless required, and responses are validated for structure before use. Sensitive data is excluded from logs and analytics.

## Development Workflow & Quality Gates

Every feature plan/spec MUST pass the Constitution Check before Phase 0 research. PRs MUST demonstrate adherence to architecture boundaries, offline fallbacks, and required tests for critical flows. Each merge request documents which principles were exercised and any temporary exceptions with a time-bound follow-up. Release artifacts include notes on data handling changes and user-facing UX impacts.

## Governance

This constitution governs NauGiDay development; conflicting practices yield to it. Amendments occur via PRs that: state the governance impact, update this file, bump the version below per semver (major for removals/overhauls, minor for new principles/sections, patch for clarifications), and update affected templates. Compliance reviews happen during plan/spec/task creation and again at PR review; exceptions are documented with owners and deadlines. Ratification date records first adoption once known; last amended reflects the most recent approved change.

**Version**: 1.0.1 | **Ratified**: TODO(RATIFICATION_DATE): original adoption date not provided | **Last Amended**: 2025-12-02
