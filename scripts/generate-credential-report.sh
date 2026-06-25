#!/usr/bin/env bash
#
# generate-credential-report.sh
# Generates and downloads the IAM credential report (the authoritative source
# for MFA, key age, and password status across all users). Read-only.
#
# Usage: ./generate-credential-report.sh [output.csv]
set -euo pipefail
OUT="${1:-credential-report.csv}"

aws iam generate-credential-report >/dev/null
# Poll until ready
for i in $(seq 1 10); do
  if aws iam get-credential-report --query 'Content' --output text 2>/dev/null \
      | base64 --decode > "$OUT"; then
    echo "==> Saved $OUT"
    exit 0
  fi
  sleep 3
done
echo "Report not ready in time." >&2; exit 1
