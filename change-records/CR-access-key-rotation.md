# CR: Access Key Rotation

| Field | Details |
|---|---|
| Change ID | CR-IAM-002 |
| Environment | Production |
| Risk Level | Medium |
| Status | Complete |

## Description
Rotated long-lived access keys (some over a year old) using the create-new / deactivate-old / verify / delete-old pattern to avoid breaking active integrations.

## Steps Performed
```bash
aws iam create-access-key --user-name <user>          # new key
# update the consumer to the new key, then:
aws iam update-access-key --user-name <user> --access-key-id <old> --status Inactive
# after a validation period:
aws iam delete-access-key --user-name <user> --access-key-id <old>
```

## Post-Change Validation
- Consumer confirmed working on the new key while old key inactive
- Old key deleted only after the validation period

## Rollback Plan
Reactivate the old key while still present (before deletion).

## Outcome
Success. Stale keys rotated with no integration downtime.
