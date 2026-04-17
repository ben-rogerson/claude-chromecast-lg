#!/usr/bin/env bash
set -euo pipefail

QUERY="${1:?Usage: yt-search.sh <query>}"
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPTS_DIR/config.sh"

# URL-encode spaces as +
ENCODED=$(echo "$QUERY" | sed 's/ /+/g')

echo "Searching YouTube for: $QUERY"
$ADB shell am force-stop com.google.android.youtube.tv
sleep 1

$ADB shell am start -a android.intent.action.VIEW \
  -d "https://www.youtube.com/results?search_query=$ENCODED" >/dev/null

"$SCRIPTS_DIR/wait-for-app.sh" "com.google.android.youtube.tv"
sleep 2

# Pick a random result (0-5 steps right)
STEPS=$(python3 -c "import random; print(random.randint(0, 5))")
echo "Selecting result at offset $STEPS..."
for i in $(seq 1 "$STEPS"); do
  $ADB shell input keyevent KEYCODE_DPAD_RIGHT
  sleep 0.2
done
$ADB shell input keyevent KEYCODE_DPAD_CENTER
