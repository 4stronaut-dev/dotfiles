-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

local HOME = os.getenv("HOME")

hl.env("XCURSOR_SIZE", "24")
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

hl.env("STEAM_COMPAT_CLIENT_INSTALL_PATH", HOME .. "/.steam/steam")
