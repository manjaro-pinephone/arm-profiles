# enable gnome-keyring-daemon
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# expand user path to local/bin for xterm link
export PATH=$HOME/.local/bin:$PATH
