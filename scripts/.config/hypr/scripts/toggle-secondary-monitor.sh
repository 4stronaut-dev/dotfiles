#!/bin/bash

CURRENT_DISABLED_VALUE=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"DP-2\") | .disabled")

if [ "$CURRENT_DISABLED_VALUE" == "false" ]; then
  hyprctl eval 'hl.monitor({output = "DP-2", disabled = true, })'

  if [ $? -eq 0 ]; then
    notify-send "Monitor DP-2 turned OFF."
  fi
else
  hyprctl eval 'hl.monitor({
    output = "DP-2",
    mode = "2560x1440@144",
    position = "2560x0",
    scale = 1,
    disabled = false,
    transform = 0,
    vrr = 0,
    bitdepth = 8,
    cm = "srgb",
  })'

  if [ $? -eq 0 ]; then
    notify-send "Monitor DP-2 turned ON."
  fi
fi
