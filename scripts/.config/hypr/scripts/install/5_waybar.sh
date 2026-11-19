#!/usr/bin/env bash

echo "###> Installing waybar and the related packages..."

# install packages for waybar
sudo pacman -S --needed --noconfirm ttf-font-awesome \
  waybar swaync pavucontrol bluez bluez-utils blueman

echo "###> Enabling Bluetooth service..."
sudo systemctl enable --now bluetooth.service

echo "###> Waybar has been installed!"
