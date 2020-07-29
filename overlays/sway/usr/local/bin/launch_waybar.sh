#!/bin/bash

THEME_DIR=$(grep '^set $theme' /etc/sway/definitions | sed 's/set $theme //g')
waybar --config /etc/sway/waybar/config --style $THEME_DIR/waybar
