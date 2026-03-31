#!/bin/bash

for src in ~/dotfiles/install/*.sh; do
  echo -e "\nInstall: $src"
  source "$src"
done

sudo updatedb

sudo pacman -Syu --noconfirm

gum confirm "Installation completed, apply REBOOT?" && reboot
