-- ┏┏ ┏━┃┏━ ┛━┏┛┏━┃┏━┃┏━┛
-- ┃┃┃┃ ┃┃ ┃┃ ┃ ┃ ┃┏┏┛━━┃
-- ┛┛┛━━┛┛ ┛┛ ┛ ━━┛┛ ┛━━┛
--      MONITORS

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
    mirror   = "eDP-1",
})

-- ┏━┃┏━┃┏━┃┏━┛┏━┃┏━┃┏┏ ┏━┛
-- ┏━┛┏┏┛┃ ┃┃ ┃┏┏┛┏━┃┃┃┃━━┃
-- ┛  ┛ ┛━━┛━━┛┛ ┛┛ ┛┛┛┛━━┛
--      PROGRAM

local terminal = "kitty"
local fileManager = "kitty --class ranger-float -e ranger"
local menu = "rofi -show drun -show-icons"
local Browser = "firefox"

--      ENV

hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)
hl.env("MOZ_ENABLE_WAYLAND", 1)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("LIBVA_DRIVER_NAME", "amdgpu")
hl.env("XDG_DESKTOP_PORTAL_DIR", "/usr/share/xdg-desktop-portal")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- ┏━┛┏━ ┃ ┃┛┏━┃┏━┃┏┏ ┏━┛┏━ ━┏┛
-- ┏━┛┃ ┃┃ ┃┃┏┏┛┃ ┃┃┃┃┏━┛┃ ┃ ┃ 
-- ━━┛┛ ┛ ┛ ┛┛ ┛━━┛┛┛┛━━┛┛ ┛ ┛
--      PERMISSION

hl.config({
    ecosystem = {
        enforce_permissions = 1,
    },

})

--    plugin = {
--        csgo_vulkan_fix = {
--            fix_mouse = true,
--        },
--    },
-- hl.plugin.csgo_vulkan_fix.vkfix_app({ app = "cs2", w = 1920, h = 1080 })

	hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
	hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
	hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

	-- ┃  ┏━┃┏━┃┃ ┃  ┏┛┃   ┏━┛┏━┛┏━┛┃  
	-- ┃  ┃ ┃┃ ┃┏┛   ┃━┏┛  ┏━┛┏━┛┏━┛┃  
	-- ━━┛━━┛━━┛┛ ┛  ━━┛   ┛  ━━┛━━┛━━┛
	--      FEELING

	hl.config({
	   general = {
		gaps_in = 7,
		gaps_out = 14,
		border_size = 2,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
		col = {
		   active_border = "rgba(225DB1aa)",
		   inactive_border = "rgba(595959aa)",
		},
	   },
	})

	hl.config({
	   decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.8,
		shadow = {
		   enabled = true,
		   range = 4,
		   render_power = 3,
		   color = "rgba(1a1a1aee)",
		},
		blur = {
		   enabled = true,
		   size = 3,
		   passes = 1,
		   vibrancy = 0.1696,
		},
	   },
	})

	hl.config({
	   animations = {
		enabled = true, -- Fix: Cambiado de { true, "please:)" } a booleano puro para evitar errores de Lua
    },
})

hl.config({
    dwindle = {
        preserve_split = 1,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

-- ┏┏ ┛┏━┛┏━┛
-- ┃┃┃┃━━┃┃  
-- ┛┛┛┛━━┛━━┛
--      INPUT

hl.config({
    input = {
        kb_layout = "latam",
        follow_mouse = 1,
        sensitivity = 0.1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

--hl.config({
--    gestures = {
--        workspace_swipe = true,
--        workspace_swipe_fingers = 3,
--  }
--})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- ┃ ┃┏━┛┃ ┃  ┏━ ┛┏━ ┏━ ┛┏━ ┏━┛┏━┛
-- ┏┛ ┏━┛━┏┛  ┏━┃┃┃ ┃┃ ┃┃┃ ┃┃ ┃━━┃
-- ┛ ┛━━┛ ┛   ━━ ┛┛ ┛━━ ┛┛ ┛━━┛━━┛
--      BINDINGS

local mainMod = "SUPER"

hl.bind(mainMod .. " + " .. "Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + " .. "C", hl.dsp.window.close())
hl.bind(mainMod .. " + " .. "M", hl.dsp.exit())
hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())
hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + " .. "J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + " .. "F", hl.dsp.exec_cmd(Browser))
hl.bind(mainMod .. " + " .. "N", hl.dsp.exec_cmd("swaync-client -t"))

hl.bind(mainMod .. " + " .. "left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + " .. "right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + " .. "up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + " .. "down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + " .. "W", hl.dsp.exec_cmd("~/.config/scripts/reload_waybar.sh"))

hl.bind("Print", hl.dsp.exec_cmd('grim ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && wl-copy < ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Captura" "$(date +%Y%m%d_%H%M%S).png" -i camera-photo"'))

hl.bind(mainMod .. " + " .. "Print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && wl-copy < ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Captura" "$(date +%Y%m%d_%H%M%S).png" -i camera-photo'))

-- ┃┃┃┛┏━ ┏━ ┏━┃┃┃┃  ┏┛┃   ┃  ┏━┃┃ ┃┏━┃┃ ┃━┏┛
-- ┃┃┃┃┃ ┃┃ ┃┃ ┃┃┃┃  ┃━┏┛  ┃  ┏━┃━┏┛┃ ┃┃ ┃ ┃ 
-- ━━┛┛┛ ┛━━ ━━┛━━┛  ━━┛   ━━┛┛ ┛ ┛ ━━┛━━┛ ┛
--      WINDOW

hl.window_rule({
    name  = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
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
    name  = "move-hyprland-run",
    match = {
        class = "hyprland-run",
    },
    move = { 20, "monitor_h-120" },
    float = true,
})

hl.window_rule({
    name  = "Abrir archivo",
    match = {
        class = "xdg-desktop-portal-gtk",
    },
    float = true,
    center = true,
})

hl.window_rule({
    name  = "windowrule-1",
    match = {
        class = "^(ranger-float)$",
    },
    float = true,
    size = { "(monitor_w*0.7)", "(monitor_h*0.7)" },
    center = true,
    opacity = 0.9,
})

hl.window_rule({
    name  = "cs2",
    match = {
        class = "^(cs2)$",
    },
    immediate = true,
})

hl.window_rule({
    name  = "^(Friends List)",
    match = {
        class = "^(steam)",
    },
    float = true,
    center = true,
})

hl.layer_rule({
    match = {
        namespace = "swaync-control-center",
    },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = {
        namespace = "swaync-notification-window",
    },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = {
        namespace = "swayosd",
    },
    blur = true,
    ignore_alpha = 0,
})

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar &")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("swaync")
end)

-- Exec (run every reload)
hl.on("config.reloaded", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
end)
