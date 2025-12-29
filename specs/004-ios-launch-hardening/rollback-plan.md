# Rollback Plan (Day-1)

## Primary Mitigation (Preferred)

1) Disable AI suggestions remotely.
2) Disable image attachments remotely.
3) Verify core recipe browsing and saving remain functional.

## Secondary Mitigation

1) Hide AI entry points from the UI (if needed).
2) Re-verify App Store compliance items in the checklist.

## Escalation

- If mitigation fails, prepare a hotfix build that keeps AI/images disabled by
  default and submit as an expedited update.
