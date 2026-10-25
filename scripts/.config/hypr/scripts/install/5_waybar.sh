#!/bin/bash

echo "###> Installing waybar and the related packages..."

# install packages for waybar
sudo pacman -S --needed --noconfirm ttf-font-awesome \
  swaync pavucontrol bluez bluez-utils blueman
yay -S --needed --noconfirm waybar-git

echo "###> Enabling Bluetooth service..."
sudo systemctl enable --now bluetooth.service

echo "###> Waybar has been installed!"
