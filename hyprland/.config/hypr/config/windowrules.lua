----------------------
---- WINDOW RULES ----
----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	-- Ignore maximize requests from all apps. You'll probably like this.
	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = {
		class = "hyprland-run",
	},
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "start-steamapps-in-fullscreen",
	match = {
		initial_class = "^(steam_app_\\d+)$",
	},
	fullscreen = true,
})

hl.window_rule({
	name = "start-waybarmodule-clickaction-in-center",
	match = {
		class = "^(waybarmodule)$",
	},
	float = true,
	center = true,
	max_size = "800 600",
})

hl.window_rule({
	name = "start-nm-connection-editor-in-center",
	match = {
		class = "^(nm-connection-editor)$",
	},
	float = true,
	center = true,
	min_size = "800 600",
	max_size = "1024 768",
})

hl.window_rule({
	name = "start-blueman-manager-in-center",
	match = {
		class = "^(blueman-manager)$",
	},
	float = true,
	center = true,
	min_size = "800 600",
	max_size = "1024 768",
})

hl.window_rule({
	name = "start-pavucontrol-in-center",
	match = {
		class = "^(org.pulseaudio.pavucontrol)$",
	},
	float = true,
	center = true,
	min_size = "1024 768",
	max_size = "1280 1024",
})

hl.window_rule({
	name = "start-solaar-in-center",
	match = {
		class = "^(solaar)$",
	},
	float = true,
	center = true,
	min_size = "800 600",
	max_size = "1024 768",
})
