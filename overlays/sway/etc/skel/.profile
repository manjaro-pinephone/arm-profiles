# enable gnome-keyring-daemon
export $(gnome-keyring-daemon --start --components=pkcs11\,secrets\,ssh)

# expand user path to local/bin for xterm link
export PATH=$HOME/.local/bin:$PATH
