#!/bin/sh
#
# Author: Appelgriebsch
# License: MIT
set -e # error if a command as non 0 exit
set -u # error if undefined variable

DMENU_OPT="--conf /etc/xdg/wofi/overlay --style /etc/xdg/wofi/style.css --location 7 --xoffset 10 --yoffset -10"

cat <<EOF | wofi --show dmenu $DMENU_OPT
<b>Manjaro ARM Sway Edition</b>
Default Modifier: <b>Alt</b>
New Terminal: <b>\$mod</b> + <b>Enter</b>
Application Launcher: <b>\$mod</b> + <b>d</b>
Command Runner: <b>\$mod</b> + <b>Shift</b> + <b>d</b>
Window Switcher: <b>\$mod</b> + <b>Ctrl</b> + <b>d</b>
Resize Mode: <b>\$mod</b> + <b>r</b>
Screenshot Mode: <b>\$mod</b> + <b>Shift</b> + <b>s</b>
Recording Mode: <b>\$mod</b> + <b>Shift</b> + <b>r</b>
EOF
