#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# make default editor Neovim
export EDITOR=nvim

# use custom fd command for fzf incl. showing hidden files by default
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# configure silver command prompt (will be removed here as soon as v2.0.0 hits repos)
SILVER=(status:black:white user:yellow:black dir:blue:black git:green:black cmdtime:magenta:black)
export SILVER_ICONS=nerd
export SILVER_SHELL=${0#-}          # bash, zsh, or fish
eval "$(silver init)"

source ~/.bash_aliases
