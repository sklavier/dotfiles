#!/bin/bash

DIR="$HOME/Imágenes/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

if grim -g "$(slurp)" "$FILE"; then
    
    wl-copy < "$FILE"
    
    
    notify-send "Captura de Pantalla" "Guardada en $DIR" \
        -i "$FILE" \
        -a "Grim" \
        --action="view=Abrir"
else
    notify-send "Captura cancelada" "No se tomó ninguna imagen" -a "Grim"
fi
