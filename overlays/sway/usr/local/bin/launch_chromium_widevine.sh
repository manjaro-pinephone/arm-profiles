#!/bin/sh

CONTAINER_DIR=/var/lib/machines/
CONTAINER_ID=chromium_widevine

machinectl -q image-status $CONTAINER_ID >/dev/null 2>&1
IMAGE_STATUS=$?

if [ $IMAGE_STATUS -ne 0 ]; then
  echo Please run the install_chromium_widevine script first!
  notify-send -u critical "Missing image" "Please run the install_chromium_widevine script!"
  exit 1
fi

if [ ! -d $HOME/.local/share/chromium_widevine ]; then
  mkdir -p $HOME/.local/share/chromium_widevine
fi

set -e

# dbus session sharing
if [[ -n $DBUS_SESSION_BUS_ADDRESS ]]; then # remove prefix
   host_dbus=${DBUS_SESSION_BUS_ADDRESS#unix:path=};
else # default guess
   host_dbus=/run/user/$UID/bus;
fi

# pulse audio access
if [[ -n $PULSE_SERVER ]]; then # remove prefix
   host_pulseaudio=${PULSE_SERVER#unix:};
else # default guess
   host_pulseaudio=/run/user/$UID/pulse;
fi

xhost +local:

pkexec systemd-nspawn --directory $CONTAINER_DIR/$CONTAINER_ID \
               --bind-ro=/tmp/.X11-unix \
               --setenv=DISPLAY=$DISPLAY \
               --setenv=PULSE_SERVER=unix:/run/user/host/pulse/native \
               --setenv=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/host/bus \
               --bind-ro=$host_pulseaudio:/run/user/host/pulse \
               --bind-ro=$host_dbus:/run/user/host/bus \
               --bind-ro=/usr/share/themes/:$XDG_DATA_HOME/themes/ \
               --bind=/dev/dri \
               --bind=/dev/shm \
               --bind=$HOME/.local/share/chromium_widevine:/home/chromium \
               --user chromium \
               --as-pid2 /usr/bin/chromium-browser "--user-agent='Mozilla/5.0 (X11; CrOS armv7l 12607.82.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.123 Safari/537.36'"
