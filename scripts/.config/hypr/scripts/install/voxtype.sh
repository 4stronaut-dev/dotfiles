#!/bin/bash

echo "###> Installing voxtype for dictation and transcribing..."

# Install needed packages
yay -S --needed --noconfirm voxtype-bin
sudo pacman -S --needed --noconfirm wtype wl-clipboard libnotify gtk4-layer-shell
# Download model and configuration
voxtype setup --download --model large-v3-turbo
# Enalbing GPU acceleration for the language model
sudo voxtype setup gpu --enable
# Remove default config file, it will be symlinked from dotfiles
rm ~/.config/voxtype/config.toml

echo "###> Voxtype installation and configuration completed."
