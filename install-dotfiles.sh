#!/bin/bash

cd "$HOME"/dotfiles

# Create symlinks to the dotfiles repo items into the config folders if all listed
stow -v -R --no-folding fish
stow -v -R --no-folding hypridle
stow -v -R --no-folding hyprland
stow -v -R --no-folding hyprlock
atow -v -R --no-folding hyprmocha
stow -v -R --no-folding hyprpaper
stow -v -R --no-folding kitty
stow -v -R --no-folding lazyvim
stow -v -R --no-folding mpv
stow -v -R --no-folding scripts
stow -v -R --no-folding starship
stow -v -R --no-folding waybar
stow -v -R --no-folding wofi
stow -v -R --no-folding yazi

# Confirm successful linking
echo "config file installation completed!"
