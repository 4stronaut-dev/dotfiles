#!/usr/bin/env bash

echo "###> Start installing Hyprland and related packages..."
# install packages for hyprland
sudo pacman -S --needed --noconfirm hyprland hypridle hyprlock \
  hyprshutdown hyprpaper awww hyprshot xdg-desktop-portal-hyprland xorg-xwayland

echo "###> Hyprland has been installed!"
