#!/bin/bash

options=(" Lock" "󰍃 Logout" "󰜉 Restart" " Power Off")
choice=$(printf '%s\n' "${options[@]}" | wofi --show dmenu --prompt "Power menu" --hide-scroll --width 140 --lines 5)

case "$choice" in
" Lock")
  hyprlock
  ;;
"󰍃 Logout")
  hyprshutdown
  ;;
"󰜉 Restart")
  hyprshutdown -t 'Restarting..' --post-cmd 'systemctl reboot'
  ;;
"Power Off")
  hyprshutdown -t 'Shutting down...' --post-cmd 'systemctl poweroff'
  ;;
esac
