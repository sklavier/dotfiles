#!/usr/bin/env bash

set -euo pipefail

PLUGIN_REPO="${HOME}/.local/src/hypr-dynamic-cursors"
PLUGIN_DIR="${HOME}/.local/lib/hyprland-plugins"
PLUGIN_STATE="/var/cache/hyprpm/${USER:-$(id -un)}/dynamic-cursors/state.toml"

if ! command -v hyprpm >/dev/null 2>&1; then
    printf 'Error: instala hyprpm antes de construir dynamic-cursors.\n' >&2
    exit 1
fi
if ! command -v pkg-config >/dev/null 2>&1 || ! pkg-config --exists hyprland; then
    printf 'Error: faltan los headers/pkg-config de Hyprland del sistema.\n' >&2
    exit 1
fi
if [[ ! -r "$PLUGIN_STATE" ]]; then
    printf 'Error: no existe el estado de hyprpm: %s\n' "$PLUGIN_STATE" >&2
    printf 'Registra el repo de dynamic-cursors con hyprpm y vuelve a intentarlo.\n' >&2
    exit 1
fi

revision=$(awk -F "'" '/^\[repository\]$/ { repository=1; next } repository && /^hash = / { print $2; exit }' "$PLUGIN_STATE")
if [[ ! "$revision" =~ ^[[:xdigit:]]{40}$ ]]; then
    printf 'Error: no se pudo leer el commit fijado por hyprpm desde %s\n' "$PLUGIN_STATE" >&2
    exit 1
fi

if [[ ! -d "$PLUGIN_REPO/.git" ]]; then
    git clone https://github.com/VirtCode/hypr-dynamic-cursors.git "$PLUGIN_REPO"
fi

git -C "$PLUGIN_REPO" fetch --depth 1 origin "$revision"
git -C "$PLUGIN_REPO" checkout --detach FETCH_HEAD
make -C "$PLUGIN_REPO" clean
make -C "$PLUGIN_REPO" -j"$(nproc)"

mkdir -p "$PLUGIN_DIR"
versioned_plugin="$PLUGIN_DIR/dynamic-cursors-${revision}.so"
install -m 755 "$PLUGIN_REPO/out/dynamic-cursors.so" "$versioned_plugin"
ln -sfn "$versioned_plugin" "$PLUGIN_DIR/dynamic-cursors.so.new"
mv -Tf "$PLUGIN_DIR/dynamic-cursors.so.new" "$PLUGIN_DIR/dynamic-cursors.so"

printf '\nBuild listo: %s\n' "$versioned_plugin"
printf 'ABI headers: %s\n' "$(grep -E '^#define (AQUAMARINE_VERSION|HYPRUTILS_VERSION)' /usr/include/hyprland/src/version.h | tr '\n' ' ')"
printf 'Reinicia Hyprland para cargar una build nueva en la sesión.\n'
