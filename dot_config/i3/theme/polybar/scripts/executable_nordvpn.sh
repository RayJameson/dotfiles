#!/usr/bin/bash

country_if_connected() {
    status=$(nordvpn status)
    is_connected=$(grep Status <(echo "$status") | cut -d ' ' -f2)
    case "$is_connected" in
        Connected)
            country=$(grep Country <(echo "$status") | cut -d ' ' -f2-)
            echo "$country"
            ;;
        Disconnected)
            echo "VPN"
            ;;
    esac
}

connect() {
    nordvpn connect "$@"
}

disconnect() {
    nordvpn disconnect
}

toggle() {
    status=$(nordvpn status)
    is_connected=$(grep Status <(echo "$status") | cut -d ' ' -f2)
    case "$is_connected" in
        Connected)
            disconnect
            ;;
        Disconnected)
            connect "$@"
            ;;
    esac
}

case "$1" in
    get_country)
        country_if_connected
        ;;
    connect)
        connect "$2"
        ;;
    disconnect)
        disconnect
        ;;
    toggle)
        toggle "$2"
        ;;
    select_and_connect)
        selected="$(nordvpn countries | tr -s " \n" "\n" | rofi -theme "$XDG_CONFIG_HOME/i3/theme/rofi/networkmenu.rasi" -normal-window -dmenu -i -p VPN)"
        if [[ -n $selected ]]; then
            connect "$selected"
        fi
esac
