#!/bin/bash

echo "###> Installing NeoVim with LazyVim..."
# install packages for NeoVim  with LazyVim extension to become an IDE
sudo pacman -S --needed --noconfirm neovim lazygit ripgrep fd ttf-nerd-fonts-symbols

if [ -d ~/.config/nvim ]; then
  rm -rf ~/.config/nvim
fi
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "###> LazyVim has been installed, plugins will be loaded on first start!"
