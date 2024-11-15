#!/usr/bin/env bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CDIR=$(cd "$DIR" && cd .. && pwd)
FOCUSED=$(grep 'ACCENT' < "$CDIR"/colors.ini | head -n1 | cut -d '=' -f2 | tr -d ' ')
UNFOCUSED=$(grep 'ALTBACKGROUND' < "$CDIR"/colors.ini | head -n1 | cut -d '=' -f2 | tr -d ' ')
DELIMITER="$1"

is_last_ws() {
    last_ws=$(i3-msg -t get_workspaces | jq 'max_by(.num) | .num')
    current_ws=$(i3-msg -t get_workspaces | jq '.[] | select(.focused == true).num')
    if [[ $last_ws -eq current_ws ]]; then
        return 0
    else
        return 1
    fi
}

show_delimiter() {
    if is_last_ws; then
        echo "%{F$FOCUSED}%{T3}$DELIMITER%{T-}%{F-}"
    else
        echo "%{F$UNFOCUSED}%{T3}$DELIMITER%{T-}%{F-}"
    fi
}

show_delimiter
