# App Store Compliance Details

## Purpose Strings

- **Camera**: We need camera access to scan ingredients.
- **Photo Library**: We need photo access to attach ingredient photos to recipes.
- **Photo Add**: We save recipe photos to your library when you choose to.

## Privacy Policy

- In-app URL: https://example.com/privacy
- Placement: Home screen (privacy icon) and release checklist screen

## App Privacy Details (Summary)

- Data collected: None (no personal data stored in the client)
- Data linked to user: None
- Tracking: No
- Analytics: Minimal event names only (`screen_view`, `scan_ingredients`,
  `save_recipe`, `generate_recipe`) without PII

## Review Notes

- AI requests are routed through a server proxy; no client secrets are shipped.
- Feature flags can disable AI/image features remotely for safety.
