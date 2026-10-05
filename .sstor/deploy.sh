#!/usr/bin/env bash
# .sstor/deploy.sh <environment> for slop-sandbox: an artificial deploy target for testing slop's
# branch deploys. It "deploys" by waiting, then records the commit in the build log. Put
# [deploy-fail] in the commit message to make it fail; [deploy-slow] makes it take 3 minutes
# (to test the waiting slot and Deploy now being disabled).
set -euo pipefail

env="${1:-${SLOP_ENVIRONMENT:-}}"
[[ -n "$env" ]] || { echo "Usage: .sstor/deploy.sh <environment>" >&2; exit 2; }

report() {
  local status="$1" message="$2"
  [[ -n "${SLOP_CALLBACK_URL:-}" ]] || return 0
  message="$(printf '%s' "$message" | tr -d '"\\' | tr -s '[:cntrl:]' ' ' | cut -c1-500)"
  curl -fsS --max-time 20 -X POST -H 'content-type: application/json' \
    --data "{\"status\":\"$status\",\"message\":\"$message\"}" "$SLOP_CALLBACK_URL" >/dev/null ||
    echo "Couldn't report the deploy result to slop" >&2
}
trap 'report failed "deploy.sh failed (line $LINENO)"' ERR

sha="${SLOP_SHA:-$(git rev-parse HEAD)}"
message="$(git log -1 --format=%B "$sha" 2>/dev/null || true)"
echo "Deploying ${SLOP_GLOB:-?} at $sha to $env"

if [[ "$message" == *"[deploy-slow]"* ]]; then sleep 180; else sleep 30; fi
if [[ "$message" == *"[deploy-fail]"* ]]; then
  echo "Failing on purpose ([deploy-fail] in the commit message)" >&2
  report failed "Failed on purpose: [deploy-fail] in the commit message"
  exit 1
fi

echo "Live in $env: $sha"
report succeeded "Deployed $sha to $env"
