# Data Model: Day-1 Launch Hardening (iOS)

## Entities

### Privacy Disclosure Item
- id (string)
- type (string: purpose_string, privacy_policy_url, app_privacy_detail)
- title (string)
- description (string)
- status (string: complete, missing, needs_review)
- lastVerifiedAt (datetime)

Validation:
- type must be one of the allowed values
- status must be one of the allowed values
- title non-empty

### Telemetry Event
- name (string: screen_view, scan_ingredients, save_recipe, generate_recipe)
- occurredAt (datetime)
- screenName (string, optional)
- metadata (map<string,string>, optional, must be non-PII)

Validation:
- name must be one of the allowed values
- metadata must not include user-entered content

### Feature Flag
- name (string: ai_enabled, images_enabled)
- enabled (bool)
- source (string: remote, cache)
- updatedAt (datetime)

Validation:
- name must be one of the allowed values

### Release Checklist Item
- id (string)
- title (string)
- status (string: pending, complete, blocked)
- owner (string, optional)
- notes (string, optional)

Validation:
- title non-empty
- status must be one of the allowed values

### Rollback Plan Step
- id (string)
- action (string)
- trigger (string)
- status (string: pending, complete)

Validation:
- action non-empty
- status must be one of the allowed values

## Relationships

- Release Checklist Item references Privacy Disclosure Item checks as part of
  compliance validation.
- Feature Flag state gates AI/image flows and informs UI availability messaging.
