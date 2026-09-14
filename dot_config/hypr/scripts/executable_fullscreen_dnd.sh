#!/usr/bin/env bash
sock="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

check_and_set_dnd() {
    local fs
    fs=$(hyprctl activewindow -j | grep -oP '"fullscreen":\s*\K[0-9]+')
    fs=${fs:-0}
    if [[ "$fs" == "0" ]]; then
        swaync-client -df
    else
        swaync-client -dn
    fi
}

while true; do
    nc -U "$sock" | while IFS= read -r line; do
        case "$line" in
            fullscreen\>\>*|workspace\>\>*|activewindow\>\>*|activewindowv2\>\>*)
                check_and_set_dnd
                ;;
        esac
    done
    sleep 1
done
