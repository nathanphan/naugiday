# Phase 0 Research — Persistent Local Recipe Storage

## Data store choice (Hive vs Drift)
- **Decision**: Use Hive for local recipe persistence.
- **Rationale**: Already referenced in project docs; lightweight, fast on mobile, supports offline boxes, and existing codegen patterns (adapters) fit the constitution’s domain/data separation.
- **Alternatives considered**: Drift/SQLite (strong relational querying but heavier setup and migration overhead); SharedPreferences/secure storage (insufficient for structured recipes).

## Schema evolution safety
- **Decision**: Version Hive type adapters carefully and default unknown fields to safe values while keeping prior indices stable.
- **Rationale**: Constitution requires schema evolution without data loss; Hive supports additive changes when indices are stable.
- **Alternatives considered**: Manual JSON serialization with custom migrations (more brittle); Drift migrations (heavier).

## Data integrity and recovery UX
- **Decision**: Wrap read/write operations with validation and surface user-facing recovery prompts when failures occur; keep successful entries intact and retriable.
- **Rationale**: Aligns with FR-005/SC-003 and constitution quality gates; avoids silent corruption.
- **Alternatives considered**: Silent retries without user messaging (risking hidden failure); aggressive purge on error (data loss).

## Navigation/back control on detail
- **Decision**: Provide an explicit back/home control in recipe detail that preserves current state and respects platform navigation patterns.
- **Rationale**: FR-008 requires a clear path back without data loss.
- **Alternatives considered**: Rely solely on OS back gestures (can be unclear/inconsistent across platforms).
