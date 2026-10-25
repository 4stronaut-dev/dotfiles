#!/bin/bash

# install packages for Thunar file manager to ability to use images and android phone storage
sudo pacman -S --needed --noconfirm thunar gvfs gvfs-mtp gnome-disk-utility

echo "###> Thunar has been installed and configured!"
