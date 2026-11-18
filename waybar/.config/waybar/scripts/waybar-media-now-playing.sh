#!/usr/bin/env bash

zscroll -l 40 \
  --delay 0.3 \
  --update-check true \
  "playerctl metadata --format '{{artist}} - {{title}}'" 2>/dev/null
