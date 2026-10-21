local wallpaper_theme = {
    active_border = "rgba(225DB1aa)",
    inactive_border = "rgba(595959aa)",
}

local theme_path = (os.getenv("HOME") or "") .. "/.cache/wal/wallpaper-theme.lua"
local theme_loaded, saved_theme = pcall(dofile, theme_path)
if theme_loaded and type(saved_theme) == "table" then
    wallpaper_theme = saved_theme
end

hl.config({
    general = {
        gaps_in = 7,
        gaps_out = 14,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
        col = {
            active_border = wallpaper_theme.active_border,
            inactive_border = wallpaper_theme.inactive_border,
        },
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

if hl.version() == "0.55.2" then
    hl.config({
        general = {
            changed_property = "value"
        }
    })
else
    hl.notification.create({
        text = "You're using: ".. hl.version(),
        timeout = 10000
    })
end
