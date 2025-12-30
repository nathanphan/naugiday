# Research: Ingredient Management

## Decision 1: Architecture layering
**Decision**: Use the existing clean architecture (domain entities/use cases, data repositories backed by Hive, presentation with Riverpod + GoRouter).
**Rationale**: Aligns with the constitution, matches current codebase structure, and preserves testability.
**Alternatives considered**: Direct Hive access from UI, feature-specific state without domain/use-case separation.

## Decision 2: Local persistence strategy
**Decision**: Persist ingredients in a dedicated Hive box with stable IDs and forward-compatible schema updates.
**Rationale**: Meets offline-first requirements and leverages existing storage dependency.
**Alternatives considered**: SQLite, shared preferences, in-memory only.

## Decision 3: Analytics events scope
**Decision**: Record minimal add/edit/delete events with timestamps and non-PII identifiers, gated by existing analytics/feature controls.
**Rationale**: Satisfies the feature requirement and data handling constraints while minimizing privacy risk.
**Alternatives considered**: Rich event payloads with user metadata, no analytics.

## Decision 4: Freshness rules
**Decision**: If expiry date is set, it determines freshness; otherwise use the manual toggle. Block saving a past expiry date.
**Rationale**: Matches clarified requirements and prevents inconsistent freshness data.
**Alternatives considered**: Manual toggle always overrides, allowing past dates with warnings.

## Decision 5: Bulk quantity updates
**Decision**: Support both set-to-value and +/- adjustments, plus mark used/bought actions.
**Rationale**: Covers common pantry workflows and aligns with clarified requirements.
**Alternatives considered**: Only absolute set or only +/- adjustments.
