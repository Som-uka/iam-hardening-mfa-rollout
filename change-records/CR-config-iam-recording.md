# CR: Enable IAM Recording in Config

| Field | Details |
|---|---|
| Change ID | CR-IAM-003 |
| Environment | Production |
| Risk Level | Low |
| Status | Complete |

## Description
Updated the configuration recorder to include global resource types so IAM changes are recorded and auditable.

## Steps Performed
```bash
aws configservice put-configuration-recorder \
  --configuration-recorder name=default,roleARN=<role-arn> \
  --recording-group allSupported=true,includeGlobalResourceTypes=true
```

## Post-Change Validation
- Confirmed recorder includes global resources
- Verified an IAM change subsequently appears in the configuration history

## Rollback Plan
Revert the recording group to its prior scope.

## Outcome
Success. IAM changes now captured in the configuration timeline.
