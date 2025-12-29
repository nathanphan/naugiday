# Contracts: Day-1 Launch Hardening (iOS)

This phase introduces minimal remote endpoints to support:
- Remote-configurable kill switches for AI and image features.
- Minimal analytics ingestion for `screen_view` and three key CTAs.

See `openapi.yaml` for the contract definitions. If the project uses an existing
proxy service, these contracts map to that service without exposing client
secrets.
