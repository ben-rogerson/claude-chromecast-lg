#!/usr/bin/env bash
set -euo pipefail

PACKAGE="${1:?Usage: launch-app.sh <package>}"
SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPTS_DIR/config.sh"

echo "Launching $PACKAGE..."
$ADB shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1 >/dev/null

"$SCRIPTS_DIR/wait-for-app.sh" "$PACKAGE"
