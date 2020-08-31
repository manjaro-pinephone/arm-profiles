#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=nvim

SILVER=(status:black:white user:yellow:black dir:blue:black git:green:black cmdtime:magenta:black)
export SILVER_ICONS=nerd
export SILVER_SHELL=$0 # bash, zsh, or fish
eval "$(silver init)"

source ~/.bash_aliases
