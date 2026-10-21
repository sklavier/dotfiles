local apply_hypr_config = hl.config
local dynamic_cursors_plugin = (os.getenv("HOME") or "") .. "/.local/lib/hyprland-plugins/dynamic-cursors.so"

if not hl.plugin.dynamic_cursors then
    local plugin_file = io.open(dynamic_cursors_plugin, "rb")
    if plugin_file then
        plugin_file:close()
        hl.plugin.load(dynamic_cursors_plugin)
    end
end

hl.on("hyprland.start", function()
    hl.exec_cmd("python3 ~/.config/scripts/wallpaper_theme.py --current")
    hl.exec_cmd("waybar &")
    hl.exec_cmd("hyprctl setcursor BreezeX-Black 32")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd("/usr/bin/qs --no-duplicate --path /home/skl4vier/.config/quickshell/wallpaper-selector")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
end)

hl.on("config.reloaded", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
end)

if hl.plugin.dynamic_cursors then
    apply_hypr_config({
        plugin = {
            dynamic_cursors = {
                enabled = true,
                mode = "tilt",
                threshold = 2,
                tilt = {
                    limit = 1500,
                    activation = "quadratic",
                    window = 80,
                    full = 45,
                },
                shake = {
                    enabled = true,
                    threshold = 6.0,
                    base = 4.0,
                    speed = 4.0,
                    influence = 0.0,
                    limit = 0.0,
                    timeout = 2000,
                    effects = false,
                    ipc = false,
                },
                hyprcursor = {
                    nearest = 1,
                    enabled = true,
                    resolution = -1,
                    fallback = "clientside",
                },
            },
        },
    })
end

wallpaper_theme_set_borders = function(active_border, inactive_border)
    apply_hypr_config({
        general = {
            col = {
                active_border = active_border,
                inactive_border = inactive_border,
            },
        },
    })
end
