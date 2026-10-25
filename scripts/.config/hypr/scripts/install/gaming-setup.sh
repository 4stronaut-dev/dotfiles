#!/bin/bash

# Define the relevant configuration files
PACMAN_CONF="/etc/pacman.conf"
PACMAN_CONF_BACKUP="${PACMAN_CONF}.bak"
HYPRLAND_CONF = "$HOME/.config/hypr/hyprland.lua"

# # Check if the file exist
# if [[ ! -f "$PACMAN_CONF" ]]; then
#  echo "Error: $PACMAN_CONF not found."
#  exit 1
# fi
#
# # Check if the file is writable
# if [[ ! -w "$PACMAN_CONF" ]]; then
#  echo "Error: Cannot write to $PACMAN_CONF. Run with sudo."
#  exit 1
# fi

# Check if [multilib] is commented (starts with #)
if ! grep -q '^\[multilib\]' "$PACMAN_CONF"; then
  sudo cp "$PACMAN_CONF" "$PACMAN_CONF_BACKUP"
  line=$(grep -n '^\s*#\s*\[multilib\]' "$PACMAN_CONF" | head -1 | cut -d: -f1)
  sed -i -e "${line}s/^#//" -e "$((line + 1))s/^#//" "$PACMAN_CONF"
  echo "###> Multilib repository has been enabled."
else
  echo "###> Multilib is already enabled."
fi

# Update package database to include 32bit packages as well.
sudo pacman -Syu --noconfirm --needed

# Install gaming packages
sudo pacman -S --needed --noconfirm lib32-mesa vulkan-radeon lib32-vulkan-radeon \
  gamemode lib32-gamemode mangohud lib32-mangohud gamescope steam lutris

# Install Proton-CachyOS (it is maintained by yay, no manual update needed via ProtonPlus)
yay -S --needed --noconfirm proton-cachyos-slr

# Notification for the user about the needed manual steps
echo "###> Gaming packages have been installed. After reboot you have to do the following steps:"
echo "> 1. Start Steam to initialize its configuration. Then close Steam."
echo "> 2. Start Steam again, go to Setting->Compatibility: enable Steamplay, and select Proton-CachyOS from the list."
echo "> 3. Start Lutris. In wine runners section configure Proton-CahcyOS as the default runner."
echo "> 4.(optional) In Lutris the runner have a system tab, here check the default game install folder, enable and configure gamemode, gamescope, mangohud."

# Ensure that $USER is in input group
if ! id -nG "$USER" | grep -qw "input"; then
  echo "Adding $USER to input group..."
  sudo gpasswd -a "$USER" input
fi

# Install and configure Xbox Series X/S wireless controller
git clone https://github.com/atar-axis/xpadneo.git "$HOME"/xpadneo
cd "$HOME"/xpadneo
sudo ./install.sh
cd ..
rm -rf xpadneo
echo "Xbox Series X/S controller driver installed."
echo "Configuring Bluetooth for Xbox Series X/S..."
echo -e "[General]\nPrivacy = device\nJustWorksRepairing = always\nClass = 0x000100\nFastConnectable = true\n\n[LE]\nMinConnectionInterval=7\nMaxConnectionInterval=9\nConnectionLatency=0" | sudo tee -a /etc/bluetooth/main.conf
echo -e "[Input]\nUserspaceHID=true" | sudo tee -a /etc/bluetooth/input.conf
echo "Configure Xbox Series X/S driver to start at boot..."
sudo modprobe hid_xpadneo
echo -e "hid_xpadneo" | sudo tee -a /etc/modules-load.d/xpadneo.conf
echo "Xbox Series X/S controller driver configured. Please do pairing after reboot!"

# Install Logitech Gamer Keyboard and Mouse handler application: Solaar
sudo pacman -S --needed --noconfirm solaar
# Apply device rules installed by Solaar to make the Logitech receiver accessible
sudo udevadm control --reload-rules

# Create necessary environment variables
echo "Create necessary environment variables..."
# Backup the original config (if not already backed up)
if [[ ! -f "$HYPR_LUA.bak" ]]; then
  cp "$HYPR_LUA" "$HYPR_LUA.bak"
  echo "> Backup created: $HYPR_LUA.bak"
fi

# List of environment variables to add
ENV_VARS=
("hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("GDK_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.env("EDITOR", "nvim")
hl.env("WINEPREFIX", HOME .. "/.wine")
hl.env("WINEARCH", "win64")
hl.env("PROTON_ENABLE_WAYLAND", "1")
hl.env("PROTON_ENABLE_HDR", "1")
hl.env("WAYLANDDRV_PRIMARY_MONITOR", "DP-1")
hl.env("DXVK_HUD", "0")
hl.env("DXVK_HDR", "1")

hl.env("STEAM_COMPAT_CLIENT_INSTALL_PATH", HOME .. "/.steam/steam")")

# Add each variable if not already present
for var in "${ENV_VARS[@]}"; do
  if ! grep -qF "$var" "$HYPR_LUA"; then
    echo "$var" >>"$HYPR_LUA"
  else
    echo "Already exists: $var"
  fi
done

echo "###> Gaming related environment variable setup completed."
