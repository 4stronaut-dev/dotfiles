#!/bin/bash

hyprctl binds -j | jq -r '
  .[] | select(.has_description) |
  "\(if .modmask == 0 then ""
     elif .modmask == 64 then "SUPER + "
     elif .modmask == 65 then "SUPER + SHIFT + "
     else "" end)\(.key):  \(.description)"
' | wofi -d -i -p "Keybinds"
