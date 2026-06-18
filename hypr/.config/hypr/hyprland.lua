-- MONITORS
local monitor1 = "desc:LG Electronics LG ULTRAGEAR 303MANJBZK27"
local monitor2 = "desc:ASUSTek COMPUTER INC PA24A J9LMQS047326"
local monitor3 = "desc:BOE 0x0B6A"
hl.monitor({ output = monitor1, mode = "2560x1440@143.97Hz", position = "0x0", scale = "1", vrr = 1 })
hl.monitor({ output = monitor2, mode = "1920x1200@59.95Hz", position = "-1920x150", scale = "1" })
hl.monitor({ output = monitor3, mode = "2560x1440@120.00Hz", position = "0x1440", scale = "1.25" })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

-- AUTOSTART
restart = function(...)
	for i, v in ipairs({...}) do hl.exec_cmd("pkill " .. tostring(v) .. "; " .. tostring(v))
end end
start = function(...)
	for i, v in ipairs({...}) do hl.exec_cmd("pidof " .. tostring(v) .. " || " .. tostring(v))
end end

hl.on("hyprland.start", function()
	restart("waybar", "hyprpaper", "hypridle", "hyprsunset", "syncthing")
end)
hl.on("config.reloaded", function()
	restart("waybar", "hyprpaper")
	start("hypridle", "hyprsunset", "syncthing")
end)
---- https://github.com/hyprwm/Hyprland/issues/2614
hl.exec_cmd("systemd-inhibit --who=\"Hyprland config\" --why=\"wlogout keybind\" --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit")
hl.on("hyprland.shutdown", function () hl.exec_cmd("kill -9 \"$(cat /tmp/.hyprland-systemd-inhibit)\"") end)

-- ENV
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- PERMS
hl.config({ ecosystem = { enforce_permissions = true } })
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/hyprlock", "screencopy", "allow")
hl.permission("/usr/lib/xdg-desktop-portal-hyprland", "screencopy", "allow")

-- RULES
hl.workspace_rule({ workspace = "w[1-5]", monitor = monitor1 })
hl.workspace_rule({ workspace = "w[6-10]", monitor = monitor2 })
hl.workspace_rule({ workspace = "1", monitor = monitor1, default = true })
hl.workspace_rule({ workspace = "6", monitor = monitor2, default = true })
hl.window_rule({ name = "steam", match = { class = "steam"}, workspace = "3" })
hl.window_rule({ name = "vesktop", match = { class = "vesktop" }, workspace = "6" })
hl.window_rule({ name = "spotify", match = { class = "Spotify" }, workspace = "7" })
hl.window_rule({ name = "suppress-maximize-events",	match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true
})

-- KEYBINDS
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "hyprlauncher"
local uwsm = "uwsm app -- "
local mainMod = "SUPER"
local specialMod = "dead_circumflex"
---- execs
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + XF86PowerOff", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'shutdown 0'"))
hl.bind(mainMod .. " + SHIFT + XF86PowerOff", hl.dsp.exec_cmd("hyprshutdown --post-cmd 'shutdown -r 0'"))
-- hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop'"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(uwsm .. terminal))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(uwsm .. terminal .. " -o confirm_os_window_close=0 btop"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(uwsm .. fileManager))
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd(uwsm .. menu))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
---- windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.window.fullscreen_state({ internal = 1, client = 2, action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
-- hl.bind(mainMod .. " + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + " .. specialMod, hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + " .. specialMod, hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
---- zoom
local function zoom(factor)
	hl.config({ cursor = { zoom_factor = math.max(1., math.min(5., hl.get_config("cursor.zoom_factor") * factor)) }})
end
hl.bind("SUPER + KP_ADD", function() zoom(1.2) end, { repeating = true })
hl.bind("SUPER + KP_SUBTRACT", function() zoom(1. / 1.2) end, { repeating = true })
hl.config({ input = { kb_layout = "de", follow_mouse = 2, sensitivity = 0, touchpad = { natural_scroll = false }}})
hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- LOOK
hl.config({
	general = {
		gaps_in = 1, gaps_out = 1, border_size = 1,
		col = {
			active_border = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
			inactive_border = "rgba(595959aa)"
		},
		resize_on_border = false, allow_tearing = true,
		layout = "dwindle"
	},
	decoration = {
		rounding = 5, rounding_power = 1,
		active_opacity = 1., inactive_opacity = .9,
		shadow = { enabled = true, range = 4, render_power = 3, color = 0xee1a1a1a },
		blur = { enabled = true, size = 3, passes = 1, vibrancy = .1696 },
	},
	animations = { enabled = true }
})

-- ANIMATIONS
hl.curve("easeOutQuint", { type = "bezier", points = {{0.23, 1}, {0.32, 1}}})
hl.curve("easeInOutCubic", { type = "bezier", points = {{0.65, 0.05}, {0.36, 1}}})
hl.curve("linear", { type = "bezier", points = {{0, 0}, {1, 1}}})
hl.curve("almostLinear", { type = "bezier", points = {{0.5, 0.5}, {0.75, 1}}})
hl.curve("quick", { type = "bezier", points = {{0.15, 0}, {0.1, 1}}})
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- LAYOUTS
hl.config({	dwindle = {	preserve_split = true }})
hl.config({ master = { new_status = "master" }})
hl.config({ scrolling = { fullscreen_on_one_column = true }})

-- MISC
hl.config({ misc = { force_default_wallpaper = 0, disable_hyprland_logo = true }})

-- PLUGINS
if hl.plugin.dynamic_cursors then
	hl.config({ plugin = { dynamic_cursors = {
		enabled = false,
		mode = "tilt",
		threshold = 2,
		tilt = {
			limit = 2000,
			activation = "quadratic",
			window = 100,
			full = 90
		},
		shake = {
			enabled = false,
			threshold = 5.,
			base = 2.,
			speed = 2.,
			influence = .3,
			limit = 0.,
			timeout = 1500,
			effects = true,
			ipc = false
		},
		hyprcursor = {
			enabled = false,
			nearest = 0,
			resolution = -1,
			fallback = "clientside"
		}
	}}})
end