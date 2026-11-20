#!/usr/bin/env bash

zscroll -l 32 \
  --delay 0.3 \
  --eval-in-shell true \
  --update-check true \
  'artist=$(playerctl metadata -f "{{artist}}" 2>/dev/null); title=$(playerctl metadata -f "{{title}}" 2>/dev/null); echo "${artist:+$artist - }$title"'
