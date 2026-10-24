local HOME = os.getenv("HOME")

return {
	terminal = "kitty",
	fileManager = "thunar",
	menu = "wofi --show drun",
	browser = "brave --password-store=basic",
	wallpaperChange = HOME .. "/.config/hypr/scripts/hyprpaper-change.sh",
	wallpaperHandler = HOME .. "/.config/hypr/scripts/hyprpaper-handler.sh",
	toggleHDR = HOME .. "/.config/hypr/scripts/toggle-hdr.sh",
	toggleSecondaryMonitor = HOME .. "/.config/hypr/scripts/toggle-secondary-monitor.sh",
	waybarWorkspaceHandler = "python3 "
		.. HOME
		.. "/.config/waybar/scripts/waybar-workspace-handler.py 2> "
		.. HOME
		.. "/.config/waybar/scripts/waybar-workspace-handler.log",
}
