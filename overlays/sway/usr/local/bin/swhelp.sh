#!/bin/bash
# Quick and hacky implementation of an help overlay using wofi
#
# Author: Appelgriebsch
# License: MIT

if [ -f $HOME/.swhelp_overlay ]; then exit 1; fi

DMENU_OPT="--conf /etc/xdg/wofi/overlay --style /etc/xdg/wofi/style.css --location 7 --xoffset 10 --yoffset -10"

spawn_help_overlay() {
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
  Open Help Overlay: <b>\$mod</b> + <b>?</b>
  Close Help Overlay: <b>Escape</b>
EOF
if [ -f $HOME/.swhelp_overlay ]; then rm $HOME/.swhelp_overlay; fi
}

touch $HOME/.swhelp_overlay
spawn_help_overlay &
