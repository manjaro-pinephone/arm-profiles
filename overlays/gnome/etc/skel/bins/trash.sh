#!/bin/bash
icon=$HOME/.local/share/applications/trash.desktop

while getopts "red" opt; do
	case $opt in
    r)
	if [ "$(gio list trash://)" ]; then
		echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon=user-trash-full\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$HOME/Documents/trash.sh -e'\n' > $icon
	fi
	;;
    e)
	gio trash --empty && echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon=user-trash\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$HOME/bins/trash.sh -e'\n' > $icon
	;;
    d)
	while sleep 5; do ($HOME/bins/trash.sh -r &) ; done
	;;
  esac
done
