#!/usr/bin/env bash

set -uo pipefail

FAILED_STEPS=()

run_step() {
    local label=$1
    shift

    printf '\n==> %s\n' "$label"
    if "$@"; then
        printf 'OK: %s\n' "$label"
    else
        local exit_code=$?
        printf 'ERROR: %s (exit code %s)\n' "$label" "$exit_code" >&2
        FAILED_STEPS+=("$label")
        return 1
    fi
}

update_everything() {
    if ! command -v yay >/dev/null 2>&1; then
        printf 'Error: yay no está instalado; no puedo actualizar paquetes AUR.\n' >&2
        FAILED_STEPS+=("yay no instalado")
        return 1
    fi

    if ! command -v hyprpm >/dev/null 2>&1; then
        run_step "Instalar Hyprland Plugin Manager" yay -S --needed hyprpm
    fi

    run_step "Actualizar paquetes oficiales y AUR" yay -Syu

    if command -v flatpak >/dev/null 2>&1; then
        run_step "Actualizar aplicaciones Flatpak" flatpak update --assumeyes
    else
        printf '\nOmitiendo Flatpak: no está instalado.\n'
    fi

    if command -v hyprpm >/dev/null 2>&1; then
        local repositories
        repositories=$(hyprpm list 2>&1 || true)

        if [[ "$repositories" != *"hyprland-plugins"* ]]; then
            run_step "Registrar plugins oficiales de Hyprland" hyprpm add https://github.com/hyprwm/hyprland-plugins
        fi
        if [[ "$repositories" != *"Repository dynamic-cursors ("* ]]; then
            run_step "Registrar dynamic-cursors" hyprpm add https://github.com/VirtCode/hypr-dynamic-cursors
        fi

        run_step "Deshabilitar builds Hyprpm incompatibles" hyprpm disable dynamic-cursors
        run_step "Deshabilitar csgo-vulkan-fix sin headers compatibles" hyprpm disable csgo-vulkan-fix
        run_step "Actualizar pins de repositorios Hyprland" hyprpm update
        run_step "Reconstruir dynamic-cursors contra headers del sistema" "$HOME/.config/scripts/build_dynamic_cursors.sh"
        run_step "Cargar plugin dinámico en la sesión actual" hyprctl plugin load "$HOME/.local/lib/hyprland-plugins/dynamic-cursors.so"
    else
        FAILED_STEPS+=("Instalar Hyprland Plugin Manager")
        printf '\nERROR: hyprpm no quedó disponible; no se pudieron actualizar plugins.\n' >&2
    fi

    ((${#FAILED_STEPS[@]} == 0))
}

clean_everything() {
    cat <<'NOTICE'

La limpieza completa:
  - quita dependencias huérfanas y todos los paquetes/builds en caché;
  - elimina runtimes Flatpak sin uso y journals antiguos (conserva 14 días);
  - vacía ~/.cache, excepto wal/ y wallpaper-theme/ usados por el tema dinámico.

Las aplicaciones podrían reconstruir cachés en su próximo inicio.
NOTICE

    local confirmation
    read -r -p 'Escribe LIMPIAR TODO para continuar: ' confirmation
    if [[ "$confirmation" != "LIMPIAR TODO" ]]; then
        printf 'Limpieza cancelada; no se borró nada.\n'
        return 0
    fi

    if command -v yay >/dev/null 2>&1; then
        run_step "Eliminar dependencias huérfanas" yay -Yc
        run_step "Vaciar por completo la caché de paquetes y builds" yay -Scc
    else
        printf 'Omitiendo limpieza de paquetes: yay no está instalado.\n'
    fi

    if command -v flatpak >/dev/null 2>&1; then
        run_step "Eliminar runtimes Flatpak sin uso" flatpak uninstall --unused --assumeyes
    fi

    if command -v journalctl >/dev/null 2>&1; then
        run_step "Rotar journals del sistema" sudo journalctl --rotate
        run_step "Limitar journals a los últimos 14 días / 100 MB" sudo journalctl --vacuum-time=14d --vacuum-size=100M
    fi

    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}"
    if [[ "$cache_dir" != "$HOME"/* || "$cache_dir" == / ]]; then
        printf 'ERROR: ruta de caché insegura; no se eliminará: %s\n' "$cache_dir" >&2
        FAILED_STEPS+=("Vaciar caché de usuario")
    elif [[ -d "$cache_dir" ]]; then
        printf '\nVaciando %s; se preservan wal/ y wallpaper-theme/.\n' "$cache_dir"
        if find "$cache_dir" -mindepth 1 -maxdepth 1 \
            ! -name wal ! -name wallpaper-theme \
            -exec rm -rf -- {} +; then
            printf 'OK: caché de usuario vaciada.\n'
        else
            FAILED_STEPS+=("Vaciar caché de usuario")
        fi
    fi

    ((${#FAILED_STEPS[@]} == 0))
}

show_result() {
    if ((${#FAILED_STEPS[@]} == 0)); then
        printf '\nOperación completada sin errores.\n'
        return 0
    fi

    printf '\nSe completó con errores en:\n' >&2
    printf '  - %s\n' "${FAILED_STEPS[@]}" >&2
    return 1
}

printf '%s\n' 'Hyprland workstation maintenance' '' \
    '1) Actualizar todo' \
    '2) Actualizar todo y luego limpieza completa' \
    '3) Solo limpieza completa' \
    '4) Salir'
read -r -p 'Selecciona [1-4]: ' choice

case "$choice" in
    1)
        update_everything
        show_result
        ;;
    2)
        if update_everything; then
            clean_everything
            show_result
        else
            printf '\nSe omite la limpieza porque alguna actualización falló.\n' >&2
            show_result
        fi
        ;;
    3)
        clean_everything
        show_result
        ;;
    4)
        printf 'Sin cambios.\n'
        ;;
    *)
        printf 'Opción inválida; no se hizo ningún cambio.\n' >&2
        exit 2
        ;;
esac
