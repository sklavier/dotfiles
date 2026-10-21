hl.window_rule({
    name = "wallpaper-selector",
    match = {
        class = "^org\\.quickshell$",
        title = "^Wallpapers$",
    },
    float = true,
    move = { 24, "monitor_h/2-window_h/2" },
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
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
    match = { class = "hyprland-run" },
    move = { 20, "monitor_h-120" },
    float = true,
})

hl.window_rule({
    name = "Abrir archivo",
    match = { class = "xdg-desktop-portal-gtk" },
    float = true,
    center = true,
})

hl.window_rule({
    name = "windowrule-1",
    match = { class = "^(ranger-float)$" },
    float = true,
    size = { "(monitor_w*0.7)", "(monitor_h*0.7)" },
    center = true,
    opacity = 0.9,
})

hl.window_rule({
    name = "cs2",
    match = { class = "^(cs2)$" },
    immediate = true,
})

hl.window_rule({
    name = "^(Friends List)",
    match = { class = "^(steam)" },
    float = true,
    center = true,
})

hl.window_rule({
    name = "Tor Browser Launcher Settings",
    match = { class = "org.torproject.torbrowser-launcher" },
    float = true,
    size = { 1079, 171 },
    center = true,
})

hl.window_rule({
    name = "privacy-browsers-float",
    match = { class = "^(Tor Browser|Mullvad Browser)$" },
    float = true,
    center = true,
    fullscreen_state = "0 0",
    suppress_event = "maximize",
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    match = { namespace = "swayosd" },
    blur = true,
    ignore_alpha = 0,
})

-- DayZ
hl.window_rule({
    name = "DayZ",
    match = { class = "^steam_app_221100$" },
    border_size = 0,
    fullscreen = true,
})

hl.window_rule({
    name = "DZL Launcher",
    match = { class = "^DZL$" },
    float = true,
    center = true,
    -- size = { 1050, 720 }
})
