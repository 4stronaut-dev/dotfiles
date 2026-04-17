#!/bin/bash

# install packages for waybar
yay -S --needed --noconfirm waybar ttf-font-awesome \
  swaync pavucontrol \
  bluez bluez-utils blueman

echo "Enabling Bluetooth service..."
sudo systemctl enable --now bluetooth.service

echo "Waybar has been installed!"
