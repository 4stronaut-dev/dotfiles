#!/bin/bash

echo "###> Installing SDDM and Sugar Candy theme..."
# install Sugar-Candy theme for sddm login manager
sudo pacman -S --needed --noconfirm sddm
yay -S --needed --noconfirm sddm-theme-sugar-candy-git

# Create hyperland config for SDDM's environment to handle monitor layout
# Check if sddm hyprland config is already exist and remove if yes
if [ -d /var/lib/sddm/.config/hypr ]; then sudo rm -rf /var/lib/sddm/.config/hypr; fi
# Create directory for the hyprland config file
sudo mkdir -p /var/lib/sddm/.config/hypr
# Create hyprland configuration for SDDM
sudo tee /var/lib/sddm/.config/hypr/hyprland.lua >/dev/null <<'EOF'
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

hl.config({
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})
EOF
# Check if there is an sddm.conf and remove if yes
if [ -f /etc/sddm.conf ]; then sudo rm /etc/sddm.conf; fi
# Create SDDM config file to use wayland backend and apply the installed theme
sudo tee /etc/sddm.conf >/dev/null <<'EOF'
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=start-hyprland

[Theme]
Current=Sugar-Candy
EOF

sudo systemctl enable sddm

echo "SDDM installation and configuration completed! KNOWN ISSUE: Wrong handling of focus for main display"
