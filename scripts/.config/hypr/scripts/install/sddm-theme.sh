#!/bin/bash

# install Sugar-Candy theme for sddm login manager
yay -S --needed --noconfirm sddm sddm-theme-sugar-candy

echo "###> Theme has been installed for sddm!"

# Create hyperland config for SDDM's environment to handle monitor layout

# Create directory for the hyprland config file
sudo mkdir -p /var/lib/sddm/.config/hypr

# Create hyprland configuration for SDDM
sudo tee /var/lib/sddm/.config/hypr/hyprland.lua >/dev/null <<'EOF'
hl.monitor({
	output = "DP-1",
	mode = "preferred",
	position = "1440x720",
	scale = "1",
})

hl.monitor({
  output = "DP-2",
  mode = "preferred",
  position = "0x0",
  scale = "1",
  transform = 3,
})

hl.config({
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
EOF

# Create SDDM config file to use wayland backend and apply the installed theme
sudo tee /etc/sddm.conf >/dev/null <<'EOF'
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=start-hyprland

[Theme]
Current=Sugar-Candy
EOF

echo "Sddm configuration completed! KNOWN ISSUE: Wrong handling of focus for main display"
