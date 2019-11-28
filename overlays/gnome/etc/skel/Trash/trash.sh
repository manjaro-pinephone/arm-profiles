#!/bin/bash
# trash.sh -s <-create autostart & application

icon=$(xdg-user-dir)/.local/share/applications/trash.desktop
start=$(xdg-user-dir)/.config/autostart/trash.desktop

while getopts "reds" opt; do
	case $opt in
    r)
	if [ "$(gio list trash://)" ]; then
		echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon='$(xdg-user-dir)/Trash/user-trash-full.svg'\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$(xdg-user-dir)/Trash/trash.sh -e'\n' > $icon
	else
		echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon='$(xdg-user-dir)/Trash/user-trash.svg'\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$(xdg-user-dir)/Trash/trash.sh -e'\n' > $icon
	fi
	;;
    e)
	gio trash --empty && echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon='$(xdg-user-dir)/Trash/user-trash.svg'\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$(xdg-user-dir)/Trash/trash.sh -e'\n' > $icon
	;;
    d)
	while sleep 30; do ($(xdg-user-dir)/Trash/trash.sh -r &) ; done
	;;
    s)
	echo -e '[Desktop Entry]\nType=Application\nName=Trash Icon\nIcon='$(xdg-user-dir)/Trash/user-trash.svg'\nExec='$(xdg-user-dir)/Trash/trash.sh -d'\n' > $start && echo -e '[Desktop Entry]\nType=Application\nName=Trash\nComment=Trash\nIcon='$(xdg-user-dir)/Trash/user-trash.svg'\nExec=nautilus trash://\nCategories=Utility;\nActions=trash;\n\n[Desktop Action trash]\nName=Empty Trash\nExec='$(xdg-user-dir)/Trash/trash.sh -e'\n' > $icon
  esac
done

