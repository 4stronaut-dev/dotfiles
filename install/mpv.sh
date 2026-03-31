#!/bin/bash

# install packages for mpv media player
yay -S --needed --noconfirm mpv yt-dlp ffmpeg libva libva-utils libvdpau mesa-vdpau libbluray vulkan-icd-loader

echo "mpv media player and essential related packages have been installed!"
