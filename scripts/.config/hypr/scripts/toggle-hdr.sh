#!/bin/bash

CURRENT_CM=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"DP-1\") | .colorManagementPreset")

if [[ "$CURRENT_CM" == "hdr" || "$CURRENT_CM" == "hdredid" ]]; then
  hyprctl eval "$(cat $HOME/.config/hypr/config/monitor-main.lua)"
  notify-send "HDR turned OFF."
else
  hyprctl eval "$(cat $HOME/.config/hypr/config/monitor-main-hdr.lua)"
  notify-send "HDR turned ON."
fi
