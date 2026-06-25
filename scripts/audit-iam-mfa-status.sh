#!/usr/bin/env bash
#
# audit-iam-mfa-status.sh
# Lists IAM users and whether each has an MFA device. Read-only.
#
# Usage: ./audit-iam-mfa-status.sh
set -euo pipefail

echo "==> Users WITHOUT MFA:"
for user in $(aws iam list-users --query 'Users[*].UserName' --output text); do
  mfa=$(aws iam list-mfa-devices --user-name "$user" \
        --query 'length(MFADevices)' --output text)
  if [[ "$mfa" == "0" ]]; then
    echo "  - $user"
  fi
done
