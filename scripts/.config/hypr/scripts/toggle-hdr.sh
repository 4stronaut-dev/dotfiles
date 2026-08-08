#!/bin/bash

CURRENT_CM=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"DP-1\") | .colorManagementPreset")

if [[ "$CURRENT_CM" == "hdr" || "$CURRENT_CM" == "hdredid" ]]; then
  hyprctl eval 'hl.monitor({
    output = "DP-1",
    mode = "2560x1440@180",
    position = "1440x720",
    scale = 1,
    vrr = 3,
    bitdepth = 8,
    cm = "auto",
    supports_wide_color = 1,
    supports_hdr = 1,
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 250,
    max_luminance = 1000,
    max_avg_luminance = 400,
  })'
  notify-send "HDR turned OFF."
else
  hyprctl eval 'hl.monitor({
    output = "DP-1",
    mode = "2560x1440@180",
    position = "1440x720",
    scale = 1,
    vrr = 3,
    bitdepth = 10,
    cm = "hdr",
    supports_wide_color = 1,
    supports_hdr = 1,
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 250,
    max_luminance = 1000,
    max_avg_luminance = 400,
  })'
  notify-send "HDR turned ON."
fi
