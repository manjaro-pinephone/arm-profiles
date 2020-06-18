#!/bin/sh

# Most pure GTK3 apps use wayland by default, but some,
# like Firefox, need the backend to be explicitely selected.
export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=v4l2_request
export GTK_THEME=Matcha-dark-sea
export GTK_CSD=0
export LD_PRELOAD=/usr/lib/libgtk3-nocsd.so.0
