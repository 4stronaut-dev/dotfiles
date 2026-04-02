#!/bin/bash

cd "$HOME"/dotfiles

# Create symlinks to the dotfiles repo items into the config folders if all listed
stow -v -R --no-folding fish
stow -v -R hypridle
stow -v -R hyprland
stow -v -R hyprlock
atow -v -R hyprmocha
stow -v -R hyprpaper
stow -v -R kitty
stow -v -R --no-folding lazyvim
stow -v -R --no-folding mpv
stow -v -R scripts
stow -v -R --no-folding starship
stow -v -R waybar
stow -v -R wofi
stow -v -R yazi

# Confirm successful linking
echo "Customized configurations have been applied!"
