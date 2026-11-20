#!/usr/bin/env bash

# "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▁▁▁▁"

animation_frames=("▅▄▂▃" "▄▂▃▄" "▂▃▄▅" "▂▃▂▄" "▃▅▃▄" "▅▂▃▄")
declare -A icons=(
  [spotify]=""
  [mpv]=""
  [vlc]="󰕼"
  [brave]=""
  [cliamp]="󰲸"
)

while :; do
  player=$(playerctl metadata -f '{{playerName}}' 2>/dev/null)
  status=$(playerctl metadata -f '{{status}}' 2>/dev/null)
  icon="${icons[$player]:-""}"
  for frame in "${animation_frames[@]}"; do
    if [ "$status" == "Playing" ]; then
      echo "$icon $frame "
    elif [ "$status" == "Paused" ]; then
      echo "$icon ▁▁▁▁ "
    else
      echo ""
    fi
    sleep 0.1
  done
done
