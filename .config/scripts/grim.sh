#!/bin/bash

# Carpeta donde se guardarán
DIR="$HOME/Imágenes/Screenshots"
mkdir -p "$DIR"

FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# Tomar la captura de un área seleccionada
if grim -g "$(slurp)" "$FILE"; then
    # Copiar al portapapeles
    wl-copy < "$FILE"
    
    # Enviar notificación a SwayNC
    notify-send "Captura de Pantalla" "Guardada en $DIR" \
        -i "$FILE" \
        -a "Grim" \
        --action="view=Abrir"
else
    notify-send "Captura cancelada" "No se tomó ninguna imagen" -a "Grim"
fi
