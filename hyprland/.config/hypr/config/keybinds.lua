local progs = require("config.programs")
local mainMod = "SUPER"

hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(progs.showKeybinds), { description = "Show all key binds." })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(progs.terminal), { description = "Open terminal." })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close active window." })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill(), { description = "Force close active window." })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock the system." })
hl.bind(
	mainMod .. " + SHIFT + L",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
	{ description = "Logout to the greeter screen." }
)
hl.bind(
	mainMod .. " + SHIFT + M",
	hl.dsp.exec_cmd(progs.toggleSecondaryMonitor),
	{ description = "Toggle ON/OFF secondary monitor." }
)
hl.bind(
	mainMod .. " + SHIFT + H",
	hl.dsp.exec_cmd(progs.toggleHDR),
	{ description = "Toggle ON/OFF HDR on the main monitor." }
)
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd("hyprctl reload"),
	{ description = "Reload Hyprland configuration." }
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(progs.fileManager), { description = "Open file explorer." })
hl.bind(
	mainMod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Toggle ON/OFF fullscreen for active window." }
)
hl.bind(
	mainMod .. " + SHIFT + F",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Maximize/Demaximize active window." }
)
hl.bind(
	mainMod .. " + T",
	hl.dsp.layout("togglesplit"),
	{ description = "Switch Vertical/Horizontal split of window tiles." }
)
hl.bind(
	mainMod .. " + SHIFT + T",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Float/Tile active window." }
)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(progs.menu), { description = "Open application launcher." })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(progs.browser), { description = "Open web browser." })
hl.bind(
	mainMod .. " + PRINT",
	hl.dsp.exec_cmd("hyprshot -m window"),
	{ description = "Create screenshot on the active window." }
)
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Create screenshot on the active screen." })
hl.bind(
	mainMod .. " + SHIFT + PRINT",
	hl.dsp.exec_cmd("hyprshot -m region"),
	{ description = "Create screenshot on a selectable region of the screeen." }
)
hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("voxtype record start"),
	{ description = "Dictation: Hold key to talk, transcription on key release." }
)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("voxtype record stop"), { release = true })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(progs.wallpaperChange), { description = "Change wallpaper random." })
-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Move focus to left." })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Move focus to down." })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Move focus to down." })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus to right." })
-- Move active window in the actual workspaces
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.move({ direction = "l" }),
	{ description = "Move active window to left." }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.move({ direction = "d" }),
	{ description = "Move active window to down." }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.move({ direction = "u" }),
	{ description = "Move active window to up." }
)
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.move({ direction = "r" }),
	{ description = "Move active window to right." }
)
-- Switch workspaces
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }), { description = "Switch to workspace [1]." })
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }), { description = "Switch to workspace [2]." })
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }), { description = "Switch to workspace [3]." })
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }), { description = "Switch to workspace [4]." })
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }), { description = "Switch to workspace [5]." })
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }), { description = "Switch to workspace [6]." })
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }), { description = "Switch to workspace [7]." })
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }), { description = "Switch to workspace [8]." })
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }), { description = "Switch to workspace [9]." })
-- Move active window to a workspace
hl.bind(
	mainMod .. " + SHIFT + 1",
	hl.dsp.window.move({ workspace = 1 }),
	{ description = "Move active window to workspace [1]." }
)
hl.bind(
	mainMod .. " + SHIFT + 2",
	hl.dsp.window.move({ workspace = 2 }),
	{ description = "Move active window to workspace [2]." }
)
hl.bind(
	mainMod .. " + SHIFT + 3",
	hl.dsp.window.move({ workspace = 3 }),
	{ description = "Move active window to workspace [3]." }
)
hl.bind(
	mainMod .. " + SHIFT + 4",
	hl.dsp.window.move({ workspace = 4 }),
	{ description = "Move active window to workspace [4]." }
)
hl.bind(
	mainMod .. " + SHIFT + 5",
	hl.dsp.window.move({ workspace = 5 }),
	{ description = "Move active window to workspace [5]." }
)
hl.bind(
	mainMod .. " + SHIFT + 6",
	hl.dsp.window.move({ workspace = 6 }),
	{ description = "Move active window to workspace [6]." }
)
hl.bind(
	mainMod .. " + SHIFT + 7",
	hl.dsp.window.move({ workspace = 7 }),
	{ description = "Move active window to workspace [7]." }
)
hl.bind(
	mainMod .. " + SHIFT + 8",
	hl.dsp.window.move({ workspace = 8 }),
	{ description = "Move active window to workspace [8]." }
)
hl.bind(
	mainMod .. " + SHIFT + 9",
	hl.dsp.window.move({ workspace = 9 }),
	{ description = "Move active window to workspace [9]." }
)

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "TBD" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "TBD" })
-- Scroll workspaces with mouse scroll
hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Switch workspace by mouse scroll up/down." }
)
hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Switch workspace by mouse scroll up/down." }
)
-- Move/resize windows LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { description = "Drag the active window." })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "Resize the active window." })
-- Close active window with mouse button 4
hl.bind("mouse:276", hl.dsp.window.close(), { description = "Close active window by mouse button 4." })
-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind(
-- 	"XF86AudioRaiseVolume",
-- 	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
-- 	{ locked = true, repeating = true }
-- )
-- hl.bind(
-- 	"XF86AudioLowerVolume",
-- 	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
-- 	{ locked = true, repeating = true }
-- )
-- hl.bind(
-- 	"XF86AudioMute",
-- 	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
-- 	{ locked = true, repeating = true }
-- )
-- hl.bind(
-- 	"XF86AudioMicMute",
-- 	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
-- 	{ locked = true, repeating = true }
-- )
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
-- hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
