#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# make default editor Neovim
export EDITOR=nvim

# use custom fd command for fzf incl. showing hidden files by default
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# configure silver command prompt
export SILVER_ICONS=nerd
export SILVER_SHELL=${0#-}          # bash, zsh, or fish
eval "$(silver init)"

source ~/.local/share/fzf-marks/fzf-marks.plugin.bash
source ~/.bash_aliases
