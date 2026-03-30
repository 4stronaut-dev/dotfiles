#!/bin/bash

# install stow (if needed)
yay -S --needed --noconfirm stow

# Create symlinks to the dotfiles repo items into the config folders if all listed
stow -v -R --no-folding fish
stow -v -R --no-folding hpaper
stow -v -R --no-folding hypridle
stow -v -R --no-folding hyprland
stow -v -R --no-folding hyprlock
stow -v -R --no-folding hyprpaper
stow -v -R --no-folding kitty
stow -v -R --no-folding starship
stow -v -R --no-folding waybar
stow -v -R --no-folding wofi
stow -v -R --no-folding yazi

# Confirm successful linking
echo "config file installation completed!"







