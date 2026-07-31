-- MONITORS
local monitor1 = "desc:LG Electronics LG ULTRAGEAR 303MANJBZK27"
local monitor2 = "desc:ASUSTek COMPUTER INC PA24A J9LMQS047326"
local monitor3 = "desc:BOE 0x0B6A"
hl.monitor({ output = monitor1, mode = "2560x1440@144", position = "0x0", scale = "1", vrr = 0 })
hl.monitor({ output = monitor2, mode = "1920x1200@60", position = "-1920x150", scale = "1" })
hl.monitor({ output = monitor3, mode = "2560x1440@120", position = "0x1440", scale = "1" })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

-- AUTOSTART
local restart = function(...)	for _, v in ipairs({...}) do hl.exec_cmd("pkill " .. tostring(v) .. "; " .. tostring(v)) end end
local start = function(...) for _, v in ipairs({...}) do hl.exec_cmd("pidof " .. tostring(v) .. " || " .. tostring(v)) end end
hl.on("hyprland.start", function()
	restart("waybar", "hyprpaper", "hypridle", "hyprsunset", "syncthing")
	hl.exec_cmd("easyeffects --service-mode -w")
	hl.exec_cmd("wl-paste --watch cliphist store")
end)
hl.on("config.reloaded", function()
	restart("waybar", "hyprpaper")
	start("hypridle", "hyprsunset", "syncthing")
	hl.exec_cmd("pkill walker; walker --gapplication-service")
end)
---- https://github.com/hyprwm/Hyprland/issues/2614
hl.exec_cmd("systemd-inhibit --who=\"Hyprland config\" --why=\"wlogout keybind\" --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit")
hl.on("hyprland.shutdown", function () hl.exec_cmd("kill -9 \"$(cat /tmp/.hyprland-systemd-inhibit)\"") end)

-- ENV
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland") -- qt theming
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_MENU_PREFIX", "plasma-") -- dolphin mime fix

-- PERMS
hl.config({ ecosystem = { enforce_permissions = true } })
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/hyprlock", "screencopy", "allow")
hl.permission("/usr/lib/xdg-desktop-portal-hyprland", "screencopy", "allow")

-- RULES
hl.window_rule({ name = "suppress-maximize-events",	match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "fullscreen-opacity", match = { fullscreen = true }, opacity = "1. override", no_dim = true })
hl.window_rule({ name = "yt-opacity", match = { class = "firefox", title = ".*(YouTube|Watch2Gether|Picture-in-Picture).*" }, opacity = "1. override", no_dim = true })
hl.window_rule({ name = "float-pop-outs", match = { class = "firefox", title = "Picture-in-Picture" }, float = true, keep_aspect_ratio = true })
hl.window_rule({ name = "pin-border", match = { pin = true }, border_size = hl.get_config("general.border_size") + 2 })
hl.window_rule({ name = "fix-xwayland-drags", match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
-- hl.window_rule({ name = "center-floats", match = { float = true }, center = true })
-- hl.window_rule({ name = "inhibit-idle", match = {fullscreen = true }, idle_inhibit = "fullscreen" })

-- KEYBINDS
local terminal = "kitty"
local fileManager = "dolphin"
local browser = "firefox"
local uwsm = "uwsm app -- "
local mainMod = "SUPER"
---- power
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind(mainMod .. " + XF86PowerOff", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'shutdown 0'"))
hl.bind(mainMod .. " + SHIFT + XF86PowerOff", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'shutdown -r 0'"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprshutdown"))
---- execs
hl.bind(mainMod .. " + L",       hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + T",       hl.dsp.exec_cmd(uwsm .. terminal))
hl.bind(mainMod .. " + E",       hl.dsp.exec_cmd(uwsm .. fileManager))
-- hl.bind(mainMod .. " + E",       hl.dsp.exec_cmd(uwsm .. terminal .. " -o confirm_os_window_close=0 y"))
hl.bind(mainMod .. " + F",       hl.dsp.exec_cmd(uwsm .. browser))
hl.bind(mainMod .. " + Escape",  hl.dsp.exec_cmd(uwsm .. terminal .. " -o confirm_os_window_close=0 btop"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("kitty -o confirm_os_window_close=0 sh -c 'kitten unicode-input | tr -d \"\\n\" | wl-copy'", { float = true }))
hl.bind(mainMod .. " + V",       hl.dsp.exec_cmd("cliphist list | walker --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("nc -U /run/user/1000/walker/walker.sock || (walker --gapplication-service && nc -U /run/user/1000/walker/walker.sock)"))
hl.bind("Print",                   hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("F19",                   hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
---- windows
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + W",         hl.dsp.window.fullscreen_state({ internal = 1, client = 2, action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + X",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P",         hl.dsp.window.pin())
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + SHIFT + left",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + dead_circumflex",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + dead_circumflex", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "e-1", on_current_monitor = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1", on_current_monitor = true }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1", on_current_monitor = true }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1", on_current_monitor = true }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i, on_current_monitor = true }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

---- zoom
local function zoom(factor)
	hl.config({ cursor = { zoom_factor = math.max(1., math.min(5., hl.get_config("cursor.zoom_factor") * factor)) }})
end
hl.bind("SUPER + KP_ADD", function() zoom(1.2) end, { repeating = true })
hl.bind("SUPER + KP_SUBTRACT", function() zoom(1. / 1.2) end, { repeating = true })
hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.config({ input = { kb_layout = "de", follow_mouse = 2, float_switch_override_focus = 0, sensitivity = 0 }})

-- LOOK
hl.config({
	general = {
		gaps_in = 3, gaps_out = 6, border_size = 1,
		col = {	active_border = "rgba(33ccffee)", inactive_border = "rgba(595959aa)" },
		resize_on_border = false, allow_tearing = true,
		layout = "dwindle"
	},
	decoration = {
		rounding = 4, rounding_power = 2,
		active_opacity = .97, inactive_opacity = .9, fullscreen_opacity = 1.,
		dim_modal = true, dim_inactive = true, dim_strength = .1,
		blur = {
			enabled = true, size = 5, passes = 1, ignore_opacity = true, xray = true,
			contrast = .7,  vibrancy = 1., vibrancy_darkness = .1
		},
		shadow = { enabled = true, range = 40, render_power = 3, color = 0x40080808 },
		glow = { enabled = false, range = 8, render_power = 4, color = 0xee33ccff }
	},
	animations = { enabled = true }
})

-- ANIMATIONS
hl.curve("easeOutQuint", { type = "bezier", points = {{0.23, 1}, {0.32, 1}}})
hl.curve("easeInOutCubic", { type = "bezier", points = {{0.65, 0.05}, {0.36, 1}}})
hl.curve("linear", { type = "bezier", points = {{0, 0}, {1, 1}}})
hl.curve("almostLinear", { type = "bezier", points = {{0.5, 0.5}, {0.75, 1}}})
hl.curve("quick", { type = "bezier", points = {{0.15, 0}, {0.1, 1}}})
hl.curve("easy", { type = "spring", mass = 1, stiffness = 70., dampening = 16. })
hl.animation({ leaf = "global", 		enabled = true, speed = 10, 	bezier = "default" })
hl.animation({ leaf = "border", 		enabled = true, speed = 5.39, 	bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", 		enabled = true, speed = 10, 	spring = "easy" })
hl.animation({ leaf = "windowsIn", 		enabled = true, speed = 4.1, 	spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", 	enabled = true, speed = 1.49, 	bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", 		enabled = true, speed = 1.73, 	bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", 		enabled = true, speed = 1.46, 	bezier = "almostLinear" })
hl.animation({ leaf = "fade", 			enabled = true, speed = 3.03, 	bezier = "quick" })
hl.animation({ leaf = "layers", 		enabled = true, speed = 3.81, 	bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", 		enabled = true, speed = 4, 		bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", 		enabled = true, speed = 1.5, 	bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", 	enabled = true, speed = 1.79, 	bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", 	enabled = true, speed = 1.39, 	bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", 	enabled = true, speed = 1.94, 	bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", 	enabled = true, speed = 1.21, 	bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", 	enabled = true, speed = 1.94, 	bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", 	enabled = true, speed = 7, 		bezier = "quick" })

-- LAYOUTS
hl.config({	dwindle = {	preserve_split = true },  master = { new_status = "master" }, scrolling = { fullscreen_on_one_column = true }})

-- MISC
hl.config({ misc = { force_default_wallpaper = 0, disable_hyprland_logo = true, middle_click_paste = false }})

-- PLUGINS
if hl.plugin.dynamic_cursors then
	hl.config({ plugin = { dynamic_cursors = {
		enabled = true, mode = "tilt", threshold = 2,
		tilt = { limit = 2000, activation = "quadratic", window = 100, full = 90 },
		shake = { enabled = true, threshold = 5., base = 2., speed = 2., influence = .3, limit = 0., timeout = 1500, effects = true, ipc = false },
		hyprcursor = { enabled = false, nearest = 0, resolution = -1, fallback = "clientside" }
	}}})
end