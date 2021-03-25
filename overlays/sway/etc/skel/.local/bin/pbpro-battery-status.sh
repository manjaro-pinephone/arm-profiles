#!/bin/bash
# simple Shellscript for battery status in waybar on Pinebook pro

PERCENT=$(cat /sys/class/power_supply/cw2015-battery/capacity)
STATUS=$(cat /sys/class/power_supply/cw2015-battery/status)

case $((
 $PERCENT >= 0 && $PERCENT <= 20 ? 1 :
 $PERCENT > 20 && $PERCENT <= 40 ? 2 :
 $PERCENT > 40 && $PERCENT <= 60 ? 3 :
 $PERCENT > 60 && $PERCENT <= 80 ? 4 : 5)) in
#
(1) TEXT=$(echo " "$PERCENT%);;
(2) TEXT=$(echo " "$PERCENT%);;
(3) TEXT=$(echo " "$PERCENT%);;
(4) TEXT=$(echo " "$PERCENT%);;
(5) TEXT=$(echo " "$PERCENT%);;
esac

case $STATUS in
#
  Charging) TEXT=$(echo " "$TEXT);;
esac

echo "{ \"text\": \"$TEXT\", \"tooltip\": \"$STATUS\", \"percentage\": $PERCENT }"
