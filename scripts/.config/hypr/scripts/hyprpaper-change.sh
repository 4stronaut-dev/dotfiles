#!/bin/bash

# wallpaper source
WALLPAPER_DIR="$HOME/dotfiles/hyprpaper/.config/hypr/hyprpapers/"
# Pick a random image
IMAGE=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
# change the wallpaper
awww img "$IMAGE" --transition-type random --transition-duration 1
