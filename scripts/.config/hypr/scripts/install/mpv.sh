#!/bin/bash

echo "###> Installing mpv and media related packages..."
# install packages for mpv media player
sudo pacman -S --needed --noconfirm mpv yt-dlp libva-utils

echo "###> mpv media player and essential related packages have been installed!"
