#!/usr/bin/env bash

status_ok() {
    status=$(playerctl -i "firefox" status 2> /dev/null)
    if [[ $status == "Stopped" || -z $status ]]; then
        return 1
    else
        return 0
    fi
}

get_song_name() {
    if status_ok; then
        song_metadata=$(playerctl metadata -i "firefox" -f "-{{ duration(mpris:length - position) }} {{ trunc(artist, 20) }} — {{ trunc(title, 15) }}" 2> /dev/null)
        echo " | $song_metadata"
    else
        echo ""
    fi
}

get_song_name
