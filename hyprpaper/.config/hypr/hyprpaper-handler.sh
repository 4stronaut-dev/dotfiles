#!/bin/bash

# timeout in [s] to the next wallpaper change
INTERVAL=120

# start awww daemon
awww-daemon &
sleep 1

while true; do
	source $HOME/.config/hypr/hyprpaper-change.sh
	sleep "$INTERVAL"
done

# Construct hyprpaper wallpaper commands
#hyprctl hyprpaper wallpaper "${DISPLAY[0]},$IMAGE,fill"
#hyprctl hyprpaper wallpaper "${DISPLAY[1]},$IMAGE,fill"
#hyprctl hyprpaper wallpaper "DP-1,$IMAGE,fill"
#hyprctl hyprpaper wallpaper "DP-2,$IMAGE,fill"
