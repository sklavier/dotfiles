#!/bin/bash
clear
echo "#################### Updating... #######################"

sudo pacman -Syyu --noconfirm
yay -Syyu --noconfirm
flatpak update -y

notify-send "System Updated!"

echo "Updated!"
