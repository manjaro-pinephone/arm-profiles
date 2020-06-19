#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

SILVER=(status:black:white user:yellow:black dir:blue:black git:green:black cmdtime:magenta:black)
export SILVER_ICONS=unicode
export SILVER_SHELL=$0 # bash, zsh, or fish
eval "$(silver init)"
