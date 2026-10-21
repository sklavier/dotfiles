local terminal = "kitty"
local file_manager = "kitty --class ranger-float -e ranger"
local menu = "rofi -show drun -show-icons"
local browser = "firefox"
local main_mod = "SUPER"

hl.bind(main_mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + C", hl.dsp.window.close())
hl.bind(main_mod .. " + M", hl.dsp.exit())
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float())
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

for workspace = 1, 5 do
    hl.bind(main_mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
    hl.bind(main_mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("F9", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true })
hl.bind("F8", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true })
hl.bind("F10", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("F3", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })
hl.bind("F12", hl.dsp.exec_cmd("ddcutil --bus 0 setvcp 10 + 10"), { locked = true })
hl.bind("F11", hl.dsp.exec_cmd("ddcutil --bus 0 setvcp 10 - 10"), { locked = true })
hl.bind("F7", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("F5", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("F5", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("F8", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(main_mod .. " + W", hl.dsp.exec_cmd("~/.config/scripts/reload_waybar.sh"))
hl.bind(main_mod .. " + SHIFT + W", hl.dsp.exec_cmd("/usr/bin/qs ipc --path /home/skl4vier/.config/quickshell/wallpaper-selector call wallpaperSelector toggle"))
hl.bind("Print", hl.dsp.exec_cmd('grim ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && wl-copy < ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Captura" "$(date +%Y%m%d_%H%M%S).png" -i camera-photo'))
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && wl-copy < ~/Imágenes/Screenshots/$(date +%Y%m%d_%H%M%S).png && notify-send "Captura" "$(date +%Y%m%d_%H%M%S).png" -i camera-photo'))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
