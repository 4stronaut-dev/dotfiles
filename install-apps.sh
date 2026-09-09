#!/bin/bash

set -e

sudo pacman -Syu --needed --noconfirm

for src in "$HOME"/dotfiles/scripts/.config/hypr/scripts/install/*.sh; do
  echo -e "\nInstall: $src"
  source "$src"
done

"$HOME"/dotfiles/apply-dotfiles.sh

gum confirm "Installation completed, reboot needed! Apply REBOOT?" && reboot
