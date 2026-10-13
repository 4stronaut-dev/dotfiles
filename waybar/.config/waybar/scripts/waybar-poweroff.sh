#!/bin/bash

options=("Lock" "Logout" "Power Off")
choice=$(printf '%s\n' "${options[@]}" |
  wofi --show dmenu --prompt "Power menu" \
    --location top_right --yoffset 10 --xoffset -110 --width 140 --lines 5)

case "$choice" in
"Lock")
  hyprlock
  ;;
"Logout")
  hyprshutdown
  ;;
"Power Off")
  hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'
  ;;
esac
