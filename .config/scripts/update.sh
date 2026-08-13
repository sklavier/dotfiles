#!/bin/bash

clear
echo "#################### Updating... #######################"

yay -Syu --noconfirm
flatpak update -y
hyprpm update

echo ""
while true; do
    read -p "Clean before update? [Y/n]" respuesta
    
    respuesta_LC="${respuesta,,}"

    if [[ -z "$respuesta" || "$respuesta_LC" == "y" ]]; then
        break
    elif [[ "$respuesta_LC" == "n" ]]; then
        echo "updated! not proceding with a clean"
        exit 0
    else
        echo "idiot, press enter or 'y' to clean, 'for' done the program"
    fi
done

clear

echo "#################### Clearing... #######################"

yay -Yc --noconfirm

sudo pacman -Sc --noconfirm
yay -Scc --noconfirm

flatpak uninstall --unused -y

sudo journalctl --vacuum-size=50M

echo ""
echo "############## (keeping wal folder)... #################"
find "$HOME/.cache" -mindepth 1 -maxdepth 1 ! -name 'wal' -exec rm -rf {} +

sudo paccache -rk1

echo "Ok!"
