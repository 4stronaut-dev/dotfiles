#!/bin/bash

# install Sugar-Candy theme for sddm login manager
yay -S --needed --noconfirm sddm-theme-sugar-candy

echo "Theme has been installed for sddm!"

# Create SDDM config to ensure it runs on X11 backend
sudo tee /etc/sddm.conf >/dev/null <<'EOF'
[General]
DisplayServer=X11
DefaultSession=hyprland.desktop

[X11]
DisplayCommand=/usr/share/sddm/scripts/Xsetup

[Theme]
Current=Sugar-Candy
EOF

# Edit Xsetup to define the monitor layout for SDDM based on X11
sudo tee -a /usr/share/sddm/scripts/Xsetup <<'EOF'
xrandr --output DP-2 --noprimary --mode 2560x1440 --rate 144 --rotate left --pos 0x0
xrandr --output DP-1 --primary --mode 2560x1440 --rate 180 --pos 1440x720
EOF

echo "Sddm configuration completed!"
