#!/usr/bin/env bash

echo "###> Installing terminal emulator..."

# install packages for kitty
sudo pacman -S --needed --noconfirm kitty fzf starship ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../../../../../.." && pwd)"

mkdir -p "$HOME/.local/share/fonts"
cp "$DOTFILES_DIR/fonts/BraveIcon.otf" "$HOME/.local/share/fonts/"

fc-cache -fv

echo "###> kitty terminal has been installed!"
