#!/bin/bash

echo "###> Installing yazi and related packages..."

# install packages for yazi
sudo pacman -S --needed --noconfirm yazi swayimg poppler p7zip jq fd ripgrep fzf resvg

echo "###> yazi has been installed!"
