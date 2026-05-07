# IAM Hardening & MFA Rollout

A methodical approach to hardening AWS IAM posture — covering user classification, MFA enforcement, access key rotation, and over-privileged policy remediation across a live AWS environment.

---

## Overview

This project documents an IAM hardening initiative across an AWS environment with 23 IAM users — the majority without MFA enabled, many with long-lived access keys, and several accounts holding overly broad permissions.

The approach classifies all IAM users before taking action, ensuring MFA rollout and key rotation are applied appropriately to each user type without disrupting active workloads.

---

## IAM User Classification

| Category | Description | MFA Approach |
|---|---|---|
| **Human** | Engineers and admins logging in interactively | Enforce MFA via IAM policy |
| **Hybrid** | Humans who also have programmatic access | Enforce MFA + rotate access keys |
| **Service** | Non-human accounts used by apps/systems | No console MFA — rotate keys on schedule |
| **Break-glass** | Emergency access accounts | MFA required, usage monitored via CloudTrail |
| **Stale** | Inactive accounts with no recent activity | Disable, then schedule for deletion |

---

## Key Findings

- Majority of human and hybrid IAM users had no MFA configured
- Access keys on active accounts ranging from 180 to 500+ days old without rotation
- AWS Config not recording IAM resource changes — no audit trail for IAM events
- Overly broad managed policies with wildcard actions on sensitive services
- No enforcement boundary preventing privilege escalation paths

---

## Audit Scripts

```bash
# Generate and decode credential report (MFA status, key age, last login)
aws iam generate-credential-report
aws iam get-credential-report \
  --query 'Content' --output text | base64 -d

# List users with no MFA devices attached
aws iam list-users --query 'Users[*].UserName' --output text | \
  xargs -I {} sh -c \
  'echo -n "{}: "; aws iam list-mfa-devices --user-name {} \
  --query "length(MFADevices)"'
```

---

## Remediation: Access Key Rotation

```bash
# 1. Create new access key
aws iam create-access-key --user-name <username>

# 2. Update consuming system, then deactivate old key
aws iam update-access-key \
  --user-name <username> \
  --access-key-id <old-key-id> --status Inactive

# 3. After validation period, delete old key
aws iam delete-access-key \
  --user-name <username> \
  --access-key-id <old-key-id>
```

---

## Remediation: Enable IAM Recording in AWS Config

```bash
# Check current recording scope
aws configservice describe-configuration-recorders

# Update to include IAM global resources
aws configservice put-configuration-recorder \
  --configuration-recorder name=default,roleARN=<role-arn> \
  --recording-group allSupported=true,includeGlobalResourceTypes=true
```

---

## Repository Structure

```
iam-hardening-mfa-rollout/
├── README.md
├── findings/
│   ├── user-classification.md
│   ├── mfa-gap-analysis.md
│   └── policy-risk-assessment.md
├── change-records/
│   ├── CR-mfa-enforcement.md
│   ├── CR-access-key-rotation.md
│   └── CR-config-iam-recording.md
└── scripts/
    ├── audit-iam-mfa-status.sh
    ├── audit-access-key-age.sh
    └── generate-credential-report.sh
```

---

## Tech Stack

- AWS IAM, AWS Config, CloudTrail, AWS CLI
- Bash, PowerShell

> All usernames, account IDs, ARNs, and policy names have been sanitized.
