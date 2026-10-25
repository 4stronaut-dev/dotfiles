#!/bin/bash

# install packages for GTK theme settings
sudo pacman -S --needed --noconfirm nwg-look
yay -S --needed --noconfirm catppuccin-gtk-theme-mocha

echo "###> GTK settings and Catppuccin Mocha GTK theme installed!"
