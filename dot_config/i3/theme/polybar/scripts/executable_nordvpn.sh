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
            echo ""
            ;;
    esac
}

connect() {
    nordvpn connect
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
            connect
            ;;
    esac
}

case "$1" in
    get_country)
        country_if_connected
        ;;
    connect)
        connect
        ;;
    disconnect)
        disconnect
        ;;
    toggle)
        toggle
        ;;
esac
