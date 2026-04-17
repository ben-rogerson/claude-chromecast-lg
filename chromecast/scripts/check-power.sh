#!/usr/bin/env bash
set -euo pipefail

status=$(lgtv power-status 2>/dev/null | python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('power', 'unknown'))" 2>/dev/null || echo "unknown")
echo "$status"
