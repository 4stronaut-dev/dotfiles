#!/bin/bash

echo "###> Installing terminal emulator..."

# install packages for kitty
yay -S --needed --noconfirm kitty fzf starship ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd

echo "###> kitty terminal has been installed!"
