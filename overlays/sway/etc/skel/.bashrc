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
source <(silver init)

# source some shell plugins for fzf
source ~/.local/share/fzf-marks/fzf-marks.plugin.bash
source ~/.local/share/fif/fif.plugin.sh
source ~/.local/share/bash-fzf/bash-fzf.rc

# source bash aliases
source ~/.bash_aliases
