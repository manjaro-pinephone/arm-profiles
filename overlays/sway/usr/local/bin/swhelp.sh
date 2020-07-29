#!/bin/bash
# Quick and hacky implementation of an help overlay using wofi
#
# Author: Appelgriebsch
# License: MIT

PIDFILE=$HOME/.swhelp_visible
FIRST_RUN=$HOME/.firstrun

if [ -f $PIDFILE ]; then exit 1; fi

spawn_help_overlay() {
cat <<EOF | wofi --show dmenu "$@"
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
if [ -f $PIDFILE ]; then rm $PIDFILE; fi
if [ -f $FIRST_RUN ]; then rm $FIRST_RUN; fi
}

for i in "$@"
do
case $i in
  --autostart)
    AUTOSTART=YES
    ;;
  *)
    # unknown option
    ;;
esac
done

if [ "$AUTOSTART" == "YES" ]; then
    if [ ! -f $FIRST_RUN ]; then exit 1; fi
fi

touch $PIDFILE
spawn_help_overlay "$@" &
