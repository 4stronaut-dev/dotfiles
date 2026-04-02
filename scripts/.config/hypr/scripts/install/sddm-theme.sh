#!/bin/bash

# install Sugar-Candy theme for sddm login manager
yay -S --needed --noconfirm sddm-theme-sugar-candy

echo "Theme has been installed for sddm!"

# Create hyperland config for SDDM's environment to handle monitor layout

# Create directory for the hyprland config file
sudo mkdir -p /var/lib/sddm/.config/hypr

# Create hyprland configuration
sudo tee /var/lib/sddm/.config/hypr/hyprland.conf >/dev/null <<'EOF'
# Create dedicated Hyprland configuration for SDDM's environment
# to handle monitor layout by wayland compositor
monitor=DP-1, preferred, 1440x720, 1
monitor=DP-2, preferred, 0x0, 1, transform, 3

misc {
    force_default_wallpaper = 0
    disable_hyprland_logo = true
}

workspace=1, monitor:DP-1
workspace=2, monitor:DP-2
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
