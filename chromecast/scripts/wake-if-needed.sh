#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPTS_DIR/config.sh"

status=$("$SCRIPTS_DIR/check-power.sh")

if [ "$status" = "on" ]; then
  echo "TV is already on."
else
  echo "TV is $status — waking..."
  lgtv on
  sleep 3
  lgtv volume set "$WAKE_VOLUME"
  echo "TV woken, volume set to $WAKE_VOLUME."
fi
