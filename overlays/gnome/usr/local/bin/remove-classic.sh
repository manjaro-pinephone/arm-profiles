#!/bin/bash

file=gnome-classic.desktop

if [ -f /usr/share/xsessions/$file ] ; then
	mv /usr/share/xsessions/$file /usr/share/xsessions/gnome-classic~
fi

