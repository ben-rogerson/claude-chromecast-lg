#!/usr/bin/env bash
set -euo pipefail

QUERY="${1:?Usage: stremio-search.sh <query>}"
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPTS_DIR/config.sh"

# Encode spaces as %s for Stremio text input
ENCODED=$(echo "$QUERY" | sed 's/ /%s/g')

echo "Opening Stremio search..."
$ADB shell am start -a android.intent.action.VIEW \
  -d "stremio:///search" \
  -n com.stremio.one/com.stremio.tv.MainActivity >/dev/null

"$SCRIPTS_DIR/wait-for-app.sh" "com.stremio.one"

sleep 0.5
$ADB shell input keyevent KEYCODE_DPAD_RIGHT
sleep 0.15
$ADB shell input keyevent KEYCODE_DPAD_RIGHT
sleep 0.15
$ADB shell input keyevent KEYCODE_DPAD_CENTER
sleep 0.5
$ADB shell input text "$ENCODED"
sleep 0.15
$ADB shell input keyevent KEYCODE_ENTER
sleep 0.15
$ADB shell input keyevent KEYCODE_DPAD_DOWN
sleep 0.15
$ADB shell input keyevent KEYCODE_DPAD_DOWN
