#!/bin/sh

# usage: import-gsettings <theme-dir> <gsettings key>:<settings.ini key> <gsettings key>:<settings.ini key> ...

prepare_gtk2_settings() {
  local theme_file=$1
  local settings_dir=$HOME

  echo "include \"$HOME/.gtkrc-2.0.mine\"" > $settings_dir/.gtkrc-2.0
  cat $1 >> $settings_dir/.gtkrc-2.0
}

prepare_gtk3_settings() {
  local theme_file=$1
  local settings_dir=$HOME/.config/gtk-3.0

  mkdir -p $settings_dir
  echo "[Settings]" > $settings_dir/settings.ini
  cat $1 | sed 's/"//g' >> $settings_dir/settings.ini
}

prepare_gtk4_settings() {
  local theme_file=$1
  local settings_dir=$HOME/.config/gtk-4.0

  mkdir -p $settings_dir
  echo "[Settings]" > $settings_dir/settings.ini
  cat $1 | sed 's/"//g' >> $settings_dir/settings.ini
}

prepare_kvantum_settings() {
  local theme_file=$1
  local settings_dir=$HOME/.config/Kvantum

  mkdir -p $settings_dir
  echo "[General]" > $settings_dir/kvantum.kvconfig
  cat $1 >> $settings_dir/kvantum.kvconfig
}

update_gsettings() {
  local theme_file=$1/gtk
  expression=""
  for pair in "$@"; do
    IFS=:; set -- $pair
    expressions="$expressions -e 's:^$2=(.*)$:gsettings set org.gnome.desktop.interface $1 \1:e'"
  done
  IFS=
  eval exec sed -E $expressions $theme_file >/dev/null
}

if [ -d "$HOME/.config" ]; then
  if [ -f "$1/gtk" ]; then
    prepare_gtk2_settings $1/gtk
    prepare_gtk3_settings $1/gtk
    prepare_gtk4_settings $1/gtk
  fi
  if [ -f "$1/kvantum" ]; then
    prepare_kvantum_settings $1/kvantum
  fi
fi

update_gsettings $@
