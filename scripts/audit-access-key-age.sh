#!/usr/bin/env bash
#
# audit-access-key-age.sh
# Flags active access keys older than a threshold (default 90 days). Read-only.
#
# Usage: ./audit-access-key-age.sh [max_age_days]
set -euo pipefail
MAX_AGE="${1:-90}"
NOW=$(date -u +%s)

for user in $(aws iam list-users --query 'Users[*].UserName' --output text); do
  aws iam list-access-keys --user-name "$user" \
    --query 'AccessKeyMetadata[?Status==`Active`].[AccessKeyId,CreateDate]' \
    --output text | while read -r kid created; do
      [[ -z "$kid" ]] && continue
      age=$(( (NOW - $(date -u -d "$created" +%s)) / 86400 ))
      if (( age > MAX_AGE )); then
        echo "  $user  $kid  ${age}d old"
      fi
  done
done
