#!/bin/bash

cd "$HOME"/

sudo pacman -Syu --needed --noconfirm
sudo pacman -S --needed --noconfirm git base-devel

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "yay has been installed!"

