# Policy Risk Assessment

## Finding
Several attached policies granted wildcard actions (`service:*`) on sensitive services, far broader than the principals actually needed.

## Risk
Wildcard policies violate least privilege: a compromised or mistaken principal can do far more damage than its job requires.

## Remediation direction
- Identify the actions each principal actually uses (via CloudTrail / Access Analyzer).
- Replace wildcard policies with scoped policies granting only those actions.
- Re-review periodically; permissions tend to accrete over time.
