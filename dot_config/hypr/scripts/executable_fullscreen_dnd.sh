#!/usr/bin/env bash

sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

nc -U "$sock" | while IFS= read -r line; do
    case "$line" in
        fullscreen\>\>1) swaync-client -dn ;;
        fullscreen\>\>0) swaync-client -df ;;
    esac
done
