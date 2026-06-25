# CR: MFA Enforcement

| Field | Details |
|---|---|
| Change ID | CR-IAM-001 |
| Environment | Production |
| Risk Level | Medium |
| Status | Complete |

## Description
Enforced MFA for human IAM users via a policy that denies sensitive actions when MFA is not present, after an enrolment drive to register devices.

## Steps Performed
```bash
# Attach a deny-without-MFA policy (condition: aws:MultiFactorAuthPresent = false)
aws iam put-user-policy --user-name <user> \
  --policy-name DenyWithoutMFA --policy-document file://deny-without-mfa.json
```

## Post-Change Validation
- Confirmed users with MFA operate normally
- Confirmed sensitive actions denied for sessions without MFA

## Rollback Plan
Detach the deny policy.

## Outcome
Success. Human console access now requires MFA.
