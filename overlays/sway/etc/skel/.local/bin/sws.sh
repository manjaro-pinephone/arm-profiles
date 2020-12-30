#!/bin/sh
#
# Author: Adrien Le Guillou
# License: MIT
set -e # error if a command as non 0 exit
set -u # error if undefined variable

# Default parameters
FORMAT="W:%W | %A - %T"
DMENU="dmenu"

# Doc
NAME="$(basename "$0")"
VERSION="0.2"
DESCRIPTION="Window switcher for Sway using dmenu"
HELP="
$NAME. $VERSION - $DESCRIPTION

Usage: 
    $NAME [-f | --format <format>] [-d | --dmenu-cmd <command>] 
          [-h | --help] [-v | --version]

Options:
    -d CMD, --dmenu-cmd CMD\t\t[default: \"dmenu\"]
        set the \`dmenu\` command to use (ex \"rofi -dmenu\")

    -f FORMAT, --format FORMAT\t\t[default: \"$FORMAT\"]
        set the format for the window picker
            %O: Output (Display)
            %W: Workspace
            %A: Application
            %T: Window Title
        (window_id) is appended at the end to identify the window

    -v, --version
        print version info and exit

    -h, --help      
        display this help and exit

Examples:
    # Default options work well if you have dmenu installed
    sws.sh

    # Use a different dmenu provider
    sws.sh --dmenu-cmd \"wofi -d\"

    # Add outputs name to the selector
    sws --format \"[%O] W:%W | %A - %T\"
"

# Options parsing
INVALID_ARGS=0 
OPTS=$(getopt -n $NAME -o f:d:hv \
       --long format:,dmenu-cmd:,help,version -- "$@") || INVALID_ARGS=1

# Exit with error and print $HELP if an invalid argument is passed
# the previous command is allowed to fail for this purpose
if [ "$INVALID_ARGS" -ne "0" ]
then
    echo "$HELP"
    exit 1
fi

# Required for getopt parsing
eval set -- "$OPTS"
unset OPTS

while :
do
    case "$1" in
        -f | --format)
            FORMAT=$2
            shift 2 
            ;;
        -d | --dmenu-cmd)
            DMENU=$2
            shift 2 
            ;;
        -h | --help)
            echo "$HELP"
            exit 
            ;;
        -v | --version)
            echo "Version $VERSION"
            exit 
            ;;
        --) 
            shift
            break 
            ;;
        *)
            echo "$HELP"
            exit 1
            break 
            ;;
    esac
done

# FORMAT as a `jq` concatenation string
FORMAT="$FORMAT (%I)"
FORMAT=$(echo "$FORMAT" | \
        sed  's/%O/" + .output + "/
              s/%W/" + .workspace + "/
              s/%A/" + .app_id + "/
              s/%T/" + .name + "/
              s/%I/" + .id + "/
              s/"/\"/
              s/\(.*\)/\"\1\"/')

# Get the container ID from the node tree
CON_ID=$(swaymsg -t get_tree | \
    jq -r ".nodes[] 
        | {output: .name, content: .nodes[]}
        | {output: .output, workspace: .content.name, 
          apps: .content 
            | .. 
            | {id: .id?|tostring, name: .name?, app_id: .app_id?, shell: .shell?} 
            | select(.app_id != null or .shell != null)}
        | {output: .output, workspace: .workspace, 
           id: .apps.id, app_id: .apps.app_id, name: .apps.name }
        | $FORMAT
        | tostring" | \
    $DMENU -i -p "Window Switcher")

# Requires the actual `id` to be at the end and between paretheses
CON_ID=${CON_ID##*(}
CON_ID=${CON_ID%)}

# Focus on the chosen window
swaymsg [con_id=$CON_ID] focus
