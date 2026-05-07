#!/usr/bin/env bash
set -euo pipefail

WORKDIR="/home/javajinx7/.openclaw/workspace"
STATUS_OUT="$(openclaw status --deep 2>&1 || true)"
GATEWAY_OUT="$(openclaw gateway status 2>&1 || true)"
AUDIT_OUT="$(openclaw security audit 2>&1 || true)"

printf '=== OPENCLAW STATUS --DEEP ===\n%s\n\n' "$STATUS_OUT"
printf '=== OPENCLAW GATEWAY STATUS ===\n%s\n\n' "$GATEWAY_OUT"
printf '=== OPENCLAW SECURITY AUDIT ===\n%s\n\n' "$AUDIT_OUT"

if echo "$STATUS_OUT" | grep -qiE 'Gateway[[:space:]]+reachable|RPC probe: ok|Runtime: running'; then
  echo 'RESULT=healthy'
  exit 0
fi

if echo "$GATEWAY_OUT" | grep -qiE 'Runtime: running|active'; then
  echo 'RESULT=degraded-but-running'
  exit 10
fi

echo 'RESULT=unhealthy'
echo 'RECOMMENDATION=approve gateway restart after reviewing status and logs'
exit 20
