#!/bin/bash

# install packages for NeoVim  with LazyVim extension to become an IDE
yay -S --needed --noconfirm neovim lazygit ripgrep fd ttf-nerd-fonts-symbols

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

echo "LazyVim has been installed, plugins will be loaded on first start!"
