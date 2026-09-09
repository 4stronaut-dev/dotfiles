#!/bin/bash

cd "$HOME"/

echo "###> Installing yay as AUR helper..."

sudo pacman -Syu --needed --noconfirm git base-devel gum

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

echo "###> yay has been installed!"
