#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm

for src in "$HOME"/dotfiles/scripts/.config/hypr/scipts/install/*.sh; do
  echo -e "\nInstall: $src"
  source "$src"
done

sudo updatedb

sudo pacman -Syu --noconfirm

"$HOME"/dotfiles/apply-dotfiles.sh

gum confirm "Installation completed, reboot needed! NOTE: after reboot, \
             run install-dotfiles.sh script! \
             Apply REBOOT?" && reboot
