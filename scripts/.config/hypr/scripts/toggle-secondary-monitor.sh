#!/bin/bash

CURRENT_DISABLED_VALUE=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"DP-2\") | .disabled")

if [ "$CURRENT_DISABLED_VALUE" == "false" ]; then
  hyprctl eval 'hl.monitor({output = "DP-2", disabled = true, })'

  if [ $? -eq 0 ]; then
    notify-send "Monitor DP-2 turned OFF."
  fi
else
  hyprctl eval "$(cat $HOME/.config/hypr/config/monitor-secondary.lua)"
  if [ $? -eq 0 ]; then
    notify-send "Monitor DP-2 turned ON."
  fi
fi
