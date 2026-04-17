#!/usr/bin/env bash
set -euo pipefail

PACKAGE="${1:?Usage: wait-for-app.sh <package> [timeout_seconds]}"
TIMEOUT="${2:-15}"
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPTS_DIR/config.sh"

echo -n "Waiting for $PACKAGE to focus"
elapsed=0
while [ "$elapsed" -lt "$TIMEOUT" ]; do
  focus=$($ADB shell dumpsys window 2>/dev/null | grep mCurrentFocus || true)
  if echo "$focus" | grep -q "$PACKAGE"; then
    echo " done."
    exit 0
  fi
  echo -n "."
  sleep 0.5
  elapsed=$((elapsed + 1))
done

echo " timed out."
exit 1
