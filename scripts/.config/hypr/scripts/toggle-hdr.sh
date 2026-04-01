#!/bin/bash

MONITOR="DP-1"
RES="2560x1440@180"
POS="1440x720" # needed for the vertical orientation of the left monitor in order to
# avoid usage of negative values in the position argument of the main monitor

CURRENT_CM=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$MONITOR\") | .cm")

if [[ "$CURRENT_CM" == "hdr" || "$CURRENT_CM" == "hdredid" ]]; then
  hyprctl keyword monitor "$MONITOR, $RES, $POS, 1, \
                             vrr, 2, bitdepth, 10, cm, wide, \
                             supports_wide_color, 1, supports_hdr, 1, \
                             sdr_min_luminance, 0.005, sdr_max_luminance, 250, \
                             max_luminance, 1000, max_avg_luminance, 400"
  notify-send "HDR turned OFF"
else
  hyprctl keyword monitor "$MONITOR, $RES, $POS, 1, \
                             vrr, 2, bitdepth, 10, cm, hdr, \
                             supports_wide_color, 1, supports_hdr, 1, \
                             sdr_min_luminance, 0.005, sdr_max_luminance, 250, \
                             max_luminance, 1000, max_avg_luminance, 400"
  notify-send "HDR turned ON"
fi
