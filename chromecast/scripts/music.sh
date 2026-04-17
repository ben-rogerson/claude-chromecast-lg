#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

HOUR=$(date +%H | sed 's/^0//')  # strip leading zero for numeric comparison

MORNING=(
  "synthwave morning drive mix"
  "90s r&b morning coffee mix"
  "progressive rock morning mix"
  "90s coffee morning mix"
  "liquid drum and bass morning mix"
  "electro house morning mix"
  "90s sunday morning aesthetic mix"
  "chillstep morning mix"
)

AFTERNOON=(
  "progressive house afternoon mix"
  "trance driving mix"
  "drum and bass workout mix"
  "EDM afternoon mix"
  "electro house afternoon mix"
  "progressive trance afternoon mix"
  "djent afternoon mix"
  "synthwave driving mix"
  "future bass afternoon mix"
  "stutter house mix"
)

EVENING=(
  "synthwave evening mix"
  "progressive trance evening mix"
  "progressive house evening mix"
  "liquid funk evening mix"
  "chillstep evening mix"
  "progressive rock evening mix"
  "dubstep evening mix"
  "drum and bass evening mix"
)

LATE_NIGHT=(
  "late night progressive trance mix"
  "darkwave late night mix"
  "djent late night mix"
  "progressive metal deep cuts mix"
  "dubstep late night mix"
  "chillstep late night mix"
  "drumstep late night mix"
  "downtempo late night mix"
  "progressive house late night mix"
  "dark synthwave late night mix"
)

if [ "$HOUR" -lt 12 ]; then
  POOL=("${MORNING[@]}")
  PERIOD="morning"
elif [ "$HOUR" -lt 17 ]; then
  POOL=("${AFTERNOON[@]}")
  PERIOD="afternoon"
elif [ "$HOUR" -lt 22 ]; then
  POOL=("${EVENING[@]}")
  PERIOD="evening"
else
  POOL=("${LATE_NIGHT[@]}")
  PERIOD="late night"
fi

COUNT=${#POOL[@]}
QUERY=$(python3 -c "import random, sys; pool=sys.argv[1:]; print(random.choice(pool))" "${POOL[@]}")

echo "[$PERIOD] Playing: $QUERY"
"$SCRIPTS_DIR/yt-search.sh" "$QUERY"
