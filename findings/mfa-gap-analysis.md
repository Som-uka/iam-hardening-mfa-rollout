# MFA Gap Analysis

## Finding
A majority of human IAM users had no MFA device registered. Console access without MFA is one of the highest-leverage risks in an account: a single phished password is full access.

## Method
The IAM credential report was used as the authoritative source (scripts/generate-credential-report.sh), cross-checked with per-user MFA device listing.

## Remediation
- Require MFA for all human users via policy that denies sensitive actions unless MFA is present.
- Track enrolment to completion rather than assuming a policy alone closes the gap.
