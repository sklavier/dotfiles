#!/bin/bash

if pgrep -x waybar > /dev/null; then
    killall waybar
    sleep 0.3
fi

waybar &

