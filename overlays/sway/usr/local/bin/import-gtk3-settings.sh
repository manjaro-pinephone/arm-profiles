#!/bin/sh

# usage: import-gsettings <theme-file> <gsettings key>:<settings.ini key> <gsettings key>:<settings.ini key> ...
prepare_gtk2_settings() {
  local theme_file=$1
  local settings_dir=$HOME

  echo "include \"/home/andi/.gtkrc-2.0.mine\"" > $settings_dir/.gtkrc-2.0
  cat $1 >> $settings_dir/.gtkrc-2.0
}

prepare_gtk3_settings() {
  local theme_file=$1
  local settings_dir=$HOME/.config/gtk-3.0

  mkdir -p $settings_dir
  echo "[settings]" > $settings_dir/settings.ini
  cat $1 >> $settings_dir/settings.ini
}

prepare_gtk4_settings() {
  local theme_file=$1
  local settings_dir=$HOME/.config/gtk-4.0

  mkdir -p $settings_dir
  echo "[settings]" > $settings_dir/settings.ini
  cat $1 >> $settings_dir/settings.ini
}

if [ -f "$1" ]; then
  prepare_gtk2_settings $1
  prepare_gtk3_settings $1
  prepare_gtk4_settings $1
fi

expression=""
for pair in "$@"; do
    IFS=:; set -- $pair
    expressions="$expressions -e 's:^$2=(.*)$:gsettings set org.gnome.desktop.interface $1 \1:e'"
done
IFS=
eval exec sed -E $expressions "${XDG_CONFIG_HOME:-$HOME/.config}"/gtk-3.0/settings.ini >/dev/null
