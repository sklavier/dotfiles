#!/usr/bin/env python3
import colorsys
import json
import os
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse

from PIL import Image

HOME = Path.home()
CACHE = HOME / ".cache" / "wal"
STATE = HOME / ".cache" / "wallpaper-theme"
WALLPAPER_DIR = HOME / "Imágenes" / "Wallpapers"
CAVA_THEMES = HOME / ".config" / "cava" / "themes"


def hex_color(rgb):
    return "#%02x%02x%02x" % tuple(max(0, min(255, round(channel))) for channel in rgb)


def rgb_to_hsv(rgb):
    return colorsys.rgb_to_hsv(*(channel / 255 for channel in rgb))


def hsv_to_hex(hsv):
    return hex_color(tuple(channel * 255 for channel in colorsys.hsv_to_rgb(*hsv)))


def extract_palette(path):
    with Image.open(path) as image:
        image = image.convert("RGB")
        image.thumbnail((96, 96))
        quantized = image.quantize(colors=24, method=Image.Quantize.MEDIANCUT)
        colors = quantized.convert("RGB").getcolors(96 * 96) or []

    samples = [(count, rgb, rgb_to_hsv(rgb)) for count, rgb in colors]
    if not samples:
        raise ValueError("No se pudieron extraer colores del wallpaper")

    dark = [(count, rgb, hsv) for count, rgb, hsv in samples if hsv[2] < 0.58]
    if dark:
        _, _, background_hsv = max(
            dark,
            key=lambda item: item[0] * (1.15 - item[2][2]) * (0.75 + item[2][1] * 0.25),
        )
    else:
        _, _, source_hsv = max(samples, key=lambda item: item[0] * item[2][1])
        background_hsv = (source_hsv[0], min(source_hsv[1], 0.3), 0.14)

    background = hsv_to_hex((background_hsv[0], min(background_hsv[1], 0.38), max(0.075, min(background_hsv[2] * 0.42, 0.17))))
    surface = hsv_to_hex((background_hsv[0], min(background_hsv[1] * 0.8, 0.32), 0.23))

    vivid = [(count, rgb, hsv) for count, rgb, hsv in samples if hsv[1] > 0.28 and 0.22 < hsv[2] < 0.96]
    if vivid:
        _, _, accent_hsv = max(vivid, key=lambda item: item[0] * item[2][1] * (0.25 + item[2][2]) ** 0.8)
    else:
        accent_hsv = ((background_hsv[0] + 0.48) % 1, 0.7, 0.82)

    accent = hsv_to_hex((accent_hsv[0], max(0.48, accent_hsv[1]), max(0.7, min(0.93, accent_hsv[2]))))
    accent_alt = hsv_to_hex((accent_hsv[0], max(0.35, accent_hsv[1] * 0.72), 0.94))

    dim = hsv_to_hex((background_hsv[0], min(background_hsv[1] * 0.45, 0.16), 0.56))
    border = hsv_to_hex((accent_hsv[0], min(accent_hsv[1] * 0.72, 0.48), 0.45))
    return {
        "background": background,
        "surface": surface,
        "accent": accent,
        "accent_alt": accent_alt,
        "text": "#eaf0f6",
        "dim": dim,
        "border": border,
        "critical": "#ff6878",
    }


def write_themes(colors, wallpaper):
    CACHE.mkdir(parents=True, exist_ok=True)
    STATE.mkdir(parents=True, exist_ok=True)
    (STATE / "current-wallpaper").write_text(str(wallpaper) + "\n", encoding="utf-8")
    (STATE / "palette.json").write_text(json.dumps({"wallpaper": str(wallpaper), **colors}, indent=2) + "\n", encoding="utf-8")

    gtk_names = {
        "background": "background",
        "surface": "surface",
        "accent": "accent",
        "accent_alt": "accent_alt",
        "text": "text",
        "dim": "dim",
        "border": "border",
        "critical": "critical",
    }
    gtk = "\n".join(f"@define-color theme_{gtk_names[name]} {value};" for name, value in colors.items()) + "\n"

    swaync = f'''@import url("file:///home/skl4vier/.cache/wal/wallpaper-theme.css");
* {{ color: @theme_text; }}
.control-center {{ background-color: @theme_background; border: 1px solid @theme_border; border-radius: 12px; margin: 10px; }}
.notification-row .notification-background .notification {{ background-color: @theme_surface; border: 1px solid @theme_border; border-radius: 12px; margin: 6px 12px; padding: 8px; }}
.notification-row .notification-background .notification.critical {{ border: 2px solid @theme_accent; }}
.widget-mpris {{ padding: 8px; }}
.widget-mpris-player {{ background-color: @theme_surface; padding: 12px; border-radius: 12px; }}
.widget-mpris .mpris-overlay button {{ background-color: @theme_border; border-radius: 100%; padding: 8px; margin: 0 4px; }}
.widget-mpris .mpris-overlay button:hover, .widget-buttons-grid flowboxchild>button:hover, .widget-buttons-grid flowboxchild>button:checked {{ background-color: @theme_accent; color: @theme_background; }}
.widget-buttons-grid {{ padding: 8px; }}
.widget-buttons-grid flowboxchild>button {{ background-color: @theme_surface; border: 1px solid @theme_border; border-radius: 8px; margin: 4px; padding: 10px; }}
.close-button {{ background-color: @theme_border; border-radius: 100%; margin: 5px; }}
.close-button:hover {{ background-color: @theme_critical; color: white; }}
'''
    (HOME / ".config" / "swaync" / "style.css").write_text(swaync, encoding="utf-8")

    swayosd = f'''@import url("file:///home/skl4vier/.cache/wal/wallpaper-theme.css");
window {{ background-color: @theme_background; color: @theme_text; border: 1px solid @theme_accent; border-top: 3px solid @theme_accent; border-radius: 10px; }}
#container {{ margin: 14px; }}
#label {{ color: @theme_text; font-family: "JetBrainsMono Nerd Font"; font-size: 14px; font-weight: 600; }}
#slider {{ background-color: @theme_surface; min-height: 10px; border-radius: 5px; }}
#slider trough {{ background-color: @theme_surface; border-radius: 5px; min-height: 10px; }}
#slider trough highlight {{ background-color: @theme_accent; border-radius: 5px; }}
'''
    (HOME / ".config" / "swayosd" / "style.css").write_text(swayosd, encoding="utf-8")
    (CACHE / "wallpaper-theme.css").write_text(gtk, encoding="utf-8")

    hyprlock = (
        f"$wallpaperPath = {wallpaper}\n"
        f"$wallpaperAccent = rgba({colors['accent'][1:]}ff)\n"
        f"$wallpaperText = rgb({colors['text'][1:]})\n"
    )
    (CACHE / "hyprlock.conf").write_text(hyprlock, encoding="utf-8")
    hyprland_lua = (
        "return {\n"
        f'    active_border = "rgba({colors["accent"][1:]}ee)",\n'
        f'    inactive_border = "rgba({colors["accent"][1:]}88)",\n'
        "}\n"
    )
    (CACHE / "wallpaper-theme.lua").write_text(hyprland_lua, encoding="utf-8")

    terminal = [
        f"foreground   {colors['text']}",
        f"background   {colors['background']}",
        f"cursor       {colors['accent']}",
        "",
        f"color0       {colors['background']}",
        f"color8       {colors['dim']}",
        f"color1       {colors['critical']}",
        f"color9       {colors['critical']}",
        f"color2       {colors['accent_alt']}",
        f"color10      {colors['accent_alt']}",
        f"color3       {colors['accent']}",
        f"color11      {colors['accent']}",
        f"color4       {colors['accent']}",
        f"color12      {colors['accent']}",
        f"color5       {colors['accent_alt']}",
        f"color13      {colors['accent_alt']}",
        f"color6       {colors['accent']}",
        f"color14      {colors['accent']}",
        f"color7       {colors['text']}",
        f"color15      {colors['text']}",
    ]
    (CACHE / "colors-kitty.conf").write_text("\n".join(terminal) + "\n", encoding="utf-8")

    CAVA_THEMES.mkdir(parents=True, exist_ok=True)
    cava_colors = [colors["accent"], colors["accent_alt"], colors["text"], colors["accent"], colors["accent_alt"], colors["text"], colors["accent"], colors["accent_alt"]]
    cava_theme = "[color]\nhorizontal_gradient = 1\n" + "\n".join(
        f"horizontal_gradient_color_{index} = '{color}'" for index, color in enumerate(cava_colors, 1)
    ) + "\n"
    (CAVA_THEMES / "wallpaper-theme").write_text(cava_theme, encoding="utf-8")

    rofi = f'''* {{
    background: {colors['background']};
    background-color: {colors['background']};
    foreground: {colors['text']};
    border-color: {colors['border']};
    selected-normal-background: {colors['accent']};
    selected-normal-foreground: {colors['background']};
    selected-active-background: {colors['accent_alt']};
    selected-active-foreground: {colors['background']};
    selected-urgent-background: {colors['critical']};
    selected-urgent-foreground: {colors['background']};
    active-background: {colors['accent_alt']};
    active-foreground: {colors['background']};
    urgent-background: {colors['critical']};
    urgent-foreground: {colors['background']};
    normal-background: {colors['background']};
    normal-foreground: {colors['text']};
    alternate-normal-background: {colors['surface']};
    alternate-normal-foreground: {colors['text']};
    dim: {colors['dim']};
    spacing: 2;
}}
window {{ background-color: @background; border: 2; border-color: @border-color; padding: 12; }}
mainbox {{ padding: 0; border: 0; }}
listview {{ spacing: 4; scrollbar: true; padding: 4 0 0; }}
element {{ padding: 8; border: 0; }}
element normal.normal {{ background-color: @normal-background; text-color: @normal-foreground; }}
element selected.normal {{ background-color: @selected-normal-background; text-color: @selected-normal-foreground; }}
element selected.active {{ background-color: @selected-active-background; text-color: @selected-active-foreground; }}
element selected.urgent {{ background-color: @selected-urgent-background; text-color: @selected-urgent-foreground; }}
inputbar {{ text-color: @foreground; padding: 8; spacing: 4; }}
entry, prompt {{ text-color: @foreground; }}
'''
    (CACHE / "colors-rofi-dark.rasi").write_text(rofi, encoding="utf-8")


def restart_if_running(program):
    running = subprocess.run(["pgrep", "-x", program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
    if not running:
        return
    subprocess.run(["pkill", "-x", program], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.Popen([program], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)


def apply_wallpaper(wallpaper, set_wallpaper=True):
    if not wallpaper.is_file() or wallpaper.suffix.lower() not in {".png", ".jpg", ".jpeg", ".webp"}:
        raise ValueError("Selecciona una imagen PNG, JPG o WebP válida")
    if not wallpaper.is_relative_to(WALLPAPER_DIR.resolve()):
        raise ValueError("El wallpaper debe estar dentro de ~/Imágenes/Wallpapers")

    colors = extract_palette(wallpaper)
    if set_wallpaper:
        subprocess.run(
            ["awww", "img", "--transition-type", "any", "--transition-step", "63", "--transition-duration", "2", "--transition-fps", "60", str(wallpaper)],
            check=True,
            stdout=subprocess.DEVNULL,
        )
    write_themes(colors, wallpaper)
    subprocess.run(
        [
            "hyprctl",
            "eval",
            f'wallpaper_theme_set_borders("rgba({colors["accent"][1:]}ee)", "rgba({colors["accent"][1:]}88)")',
        ],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    subprocess.run(["swaync-client", "--reload-css"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run(["kitten", "@", "set-colors", "--all", "--configured", str(CACHE / "colors-kitty.conf")], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run(["pkill", "-USR1", "-x", "kitty"], check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    restart_if_running("waybar")
    restart_if_running("swayosd-server")
    return colors


def main():
    args = sys.argv[1:]
    generate_only = bool(args and args[0] == "--generate-only")
    current_wallpaper = bool(args and args[0] == "--current")
    if current_wallpaper:
        try:
            state = json.loads(subprocess.check_output(["waypaper", "--list"], text=True))
            raw_path = next((item["wallpaper"] for item in state if item.get("wallpaper")), "")
        except (OSError, subprocess.CalledProcessError, json.JSONDecodeError, KeyError) as error:
            print(f"No se pudo leer el wallpaper actual de Waypaper: {error}", file=sys.stderr)
            return 1
    else:
        raw_path = args[1] if generate_only and len(args) > 1 else (args[0] if args and not generate_only else "")
    if raw_path.startswith("file:"):
        raw_path = unquote(urlparse(raw_path).path)
    wallpaper = Path(raw_path).expanduser().resolve()
    try:
        colors = apply_wallpaper(wallpaper, set_wallpaper=not (generate_only or current_wallpaper))
    except Exception as error:
        print(str(error), file=sys.stderr)
        return 1
    print(json.dumps({"wallpaper": str(wallpaper), **colors}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
