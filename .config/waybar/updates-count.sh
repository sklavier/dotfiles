#!/usr/bin/env bash

set -u

repo_updates=$(checkupdates 2>/dev/null)
repo_status=$?
if (( repo_status != 0 && repo_status != 2 )); then
    printf '{"text":"?","tooltip":"No se pudieron consultar los repositorios","class":"error"}\n'
    exit 0
fi

aur_updates=$(yay -Qua 2>&1)
aur_status=$?
if (( aur_status != 0 )) && [[ -n "$aur_updates" ]]; then
    printf '{"text":"?","tooltip":"No se pudieron consultar las actualizaciones AUR","class":"error"}\n'
    exit 0
fi

repo_count=$(awk 'NF { count++ } END { print count + 0 }' <<< "$repo_updates")
aur_count=$(awk '$1 ~ /^aur\// { count++ } END { print count + 0 }' <<< "$aur_updates")
total=$((repo_count + aur_count))

if (( total == 0 )); then
    printf '{"text":"","tooltip":"El sistema está actualizado","class":"updated"}\n'
else
    printf '{"text":"󰏖 %d","tooltip":"%d actualizaciones: %d repositorios, %d AUR","class":"updates"}\n' \
        "$total" "$total" "$repo_count" "$aur_count"
fi