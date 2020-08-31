# enable gnome-keyring-daemon
export $(gnome-keyring-daemon --start --components=pkcs11\,secrets\,ssh)
