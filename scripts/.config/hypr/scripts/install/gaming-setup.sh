#!/usr/bin/env bash
set -e

echo "###> Start installing gaming setup..."

PACMAN_CONF="/etc/pacman.conf"

# CONCEPT:
#  - repalce the arch default kernel with cachyos BORE kernel
#  - Add the ZEN5 cpu core oprimized packages from cachyos repos
#  - regenerate GRUB to show all kernel oprions and use BORE as default
#  - add all gaming related packages including proton-cachyos
#  - install and configure driver for wireless Bluetooth XBox X/S gamepad

# ============================================================
# Add a pacman hook to rebuild GRUB config after kernel update
# ============================================================
if [ ! -f /etc/pacman.d/hooks/grub-update.hook ]; then
  sudo tee /etc/pacman.d/hooks/grub-update.hook <<'EOF'
[Trigger]
Operation = Install
Operation = Remove
Operation = Upgrade
Type = File
Target = boot/vmlinuz*

[Action]
Description = Updating GRUB configuration...
When = PostTransaction
Depends = grub
Exec = /usr/bin/grub-mkconfig -o /boot/grub/grub.cfg
EOF
  echo "###> GRUB update hook added."
fi

# ============================================================
# CachyOS Keyring + Mirrorlist (znver4)
# ============================================================
if [ ! -f /usr/share/pacman/keyrings/cachyos.gpg ]; then
  echo "###> Setting up CachyOS keyring..."
  sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key F3B607488DB35A47

  sudo pacman -U \
    'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst'

  echo "###> Keyring installed."
else
  echo "###> CachyOS keyring already present."
fi

# Create mirrorlist file manually (avoids version-dependent package URLs)
if [ ! -f /etc/pacman.d/cachyos-v4-mirrorlist ]; then
  echo "Server = https://mirror.cachyos.org/repo/x86_64_v4/\$repo" |
    sudo tee /etc/pacman.d/cachyos-v4-mirrorlist >/dev/null
  echo "###> CachyOS v4 mirrorlist created."
else
  echo "###> CachyOS v4 mirrorlist already present."
fi

# ============================================================
# Add CachyOS znver4 repos to pacman.conf (above arch repos)
# ============================================================
if ! grep -q '^\[cachyos-znver4\]' "$PACMAN_CONF"; then
  sudo cp "$PACMAN_CONF" "${PACMAN_CONF}.bak.$(date +%Y%m%d%H%M%S)"
  echo "###> Backup created."

  # Enable x86_64_v4 architecture for pacman
  sed -i 's/^Architecture = auto/Architecture = x86_64 x86_64_v4/' "$PACMAN_CONF"

  # Insert cachyos optimized repos before the [core] section
  CORE_LINE=$(grep -n '^\[core\]' "$PACMAN_CONF" | head -1 | cut -d: -f1)
  if [ -n "$CORE_LINE" ]; then
    sed -i "${CORE_LINE}i \\
# CachyOS znver4 optimized repositories\\
[cachyos-znver4]\\
Include = /etc/pacman.d/cachyos-v4-mirrorlist\\
\\
[cachyos-core-znver4]\\
Include = /etc/pacman.d/cachyos-v4-mirrorlist\\
\\
[cachyos-extra-znver4]\\
Include = /etc/pacman.d/cachyos-v4-mirrorlist" "$PACMAN_CONF"
    echo "###> CachyOS znver4 repos added."
  else
    echo "###> WARNING: Could not find [core] in pacman.conf, appending repos."
    cat <<'EOF' | sudo tee -a "$PACMAN_CONF"

# CachyOS znver4 optimized repositories
[cachyos-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-core-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-extra-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist
EOF
  fi
else
  echo "###> CachyOS znver4 repos already configured."
fi

# ============================================================
# Enable Multilib
# ============================================================
if ! grep -q '^\[multilib\]' "$PACMAN_CONF"; then
  line=$(grep -n '^\s*#\s*\[multilib\]' "$PACMAN_CONF" | head -1 | cut -d: -f1)
  sed -i -e "${line}s/^#//" -e "$((line + 1))s/^#//" "$PACMAN_CONF"
  echo "###> Multilib repository has been enabled."
else
  echo "###> Multilib is already enabled."
fi

# ============================================================
# Full system update (now includes CachyOS optimized packages)
# ============================================================
echo "###> Updating system (this will pull optimized packages)..."
sudo pacman -Syyu --noconfirm

# ============================================================
# Install CachyOS BORE kernel
# ============================================================
if ! pacman -Q linux-cachyos-bore &>/dev/null; then
  echo "###> Installing linux-cachyos-bore kernel..."
  sudo pacman -S --noconfirm linux-cachyos-bore linux-cachyos-bore-headers
  echo "###> BORE kernel installed."
else
  echo "###> BORE kernel already installed."
fi

# ============================================================
# Set CachyOS BORE kernel as the default in GRUB
# ============================================================
echo "###> Configuring bootloader..."
if ! grep -q '^GRUB_TOP_LEVEL' /etc/default/grub; then
  sudo sed -i '/^GRUB_DEFAULT=0/a GRUB_TOP_LEVEL="/boot/vmlinuz-linux-cachyos-bore"' /etc/default/grub
  echo "###> Bore kernel set as GRUB default."
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "###> GRUB config regenerated."

# ============================================================
# Gaming packages
# ============================================================
# mesa and vulkan 64bit and 32bit , steam, lutris, etc..
echo "###> Installing gaming packages..."
sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
  gamemode lib32-gamemode mangohud lib32-mangohud gamescope steam lutris

# Proton-CachyOS from AUR
yay -S --needed --noconfirm proton-cachyos-slr

echo "###> Gaming packages have been installed. After reboot you have to do the following steps:"
echo "> 1. Start Steam to initialize its configuration. Then close Steam."
echo "> 2. Start Steam again, go to Setting->Compatibility: enable Steamplay, and select Proton-CachyOS from the list."
echo "> 3. Start Lutris. In wine runners section configure Proton-CachyOS as the default runner."
echo "> 4. (optional) In Lutris the runner has a system tab, here check the default game install folder, enable and configure gamemode, gamescope, mangohud."

# ============================================================
# XBox Series X/S bluetooth gamepad configuration
# ============================================================
# Add my user to input group
if ! id -nG "$USER" | grep -qw "input"; then
  echo "###> Adding $USER to input group..."
  sudo gpasswd -a "$USER" input
else
  echo "###> $USER is already in input group."
fi

# Driver installation
echo "###> Installing Xbox Series X/S controller driver..."
sudo pacman -S --needed --noconfirm dkms linux-cachyos-bore-headers
yay -S --needed --noconfirm xpadneo-dkms

echo "###> Configuring Bluetooth for Xbox Series X/S..."
# Append only if not already present
if ! grep -q "Privacy = device" /etc/bluetooth/main.conf 2>/dev/null; then
  echo -e "\n[General]\nPrivacy = device\nJustWorksRepairing = always\nClass = 0x000100\nFastConnectable = true\n\n[LE]\nMinConnectionInterval=7\nMaxConnectionInterval=9\nConnectionLatency=0" | sudo tee -a /etc/bluetooth/main.conf >/dev/null
fi
if ! grep -q "UserspaceHID=true" /etc/bluetooth/input.conf 2>/dev/null; then
  echo -e "\n[Input]\nUserspaceHID=true" | sudo tee -a /etc/bluetooth/input.conf >/dev/null
fi

echo "###> Configuring xpadneo to load at boot..."
sudo modprobe hid_xpadneo
if [ ! -f /etc/modules-load.d/xpadneo.conf ]; then
  echo "hid_xpadneo" | sudo tee /etc/modules-load.d/xpadneo.conf >/dev/null
fi
echo "###> Xbox Series X/S controller driver configured. Please reboot then do the pairing after reboot!"

# ============================================================
# Logitech Keyboard and Mouse tool installation
# ============================================================
sudo pacman -S --needed --noconfirm solaar
sudo udevadm control --reload-rules

echo "###> Gaming setup installation completed!"
