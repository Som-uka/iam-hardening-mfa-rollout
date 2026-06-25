# User Classification

Before enforcing controls, IAM principals were classified by type so the right control applies to each.

| Class | Description | Control approach |
|---|---|---|
| Human / console | People logging into the console | Enforce MFA; password policy |
| Programmatic | Service/automation users with access keys | Rotate keys; prefer roles over long-lived keys |
| Break-glass | Emergency-only accounts | MFA + tightly monitored + rarely used |
| Service-linked / roles | AWS-managed or assumed roles | No long-lived credentials; scope policies |

## Why classify first
Applying "enforce MFA" blindly to a programmatic user that only uses access keys achieves nothing. Classification ensures each principal gets a control that actually fits how it authenticates.
