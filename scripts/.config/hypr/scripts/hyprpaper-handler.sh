#!/bin/bash

# timeout in [s] to the next wallpaper change
INTERVAL=120

# start awww daemon
awww-daemon &
sleep 1

while true; do
  source $HOME/.config/hypr/scripts/hyprpaper-change.sh
  sleep "$INTERVAL"
done
