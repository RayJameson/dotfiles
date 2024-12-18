#!/bin/sh

sleep_pid=0

refresh_script() {
    if [ $sleep_pid -ne 0 ]; then
        kill $sleep_pid
    fi
}

trap refresh_script USR1

check_updates() {
    if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
        updates_arch=0
    fi

    if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l); then
        # if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
        # if ! updates_aur=$(cower -u 2> /dev/null | wc -l); then
        # if ! updates_aur=$(trizen -Su --aur --quiet | wc -l); then
        # if ! updates_aur=$(pikaur -Qua 2> /dev/null | wc -l); then
        # if ! updates_aur=$(rua upgrade --printonly 2> /dev/null | wc -l); then
        updates_aur=0
        fi

        updates=$((updates_arch + updates_aur))

        if [ "$updates" -gt 0 ]; then
            echo "$updates"
        else
            echo ""
        fi
}

install_updates() {
    # i3 directory
    DIR="$HOME/.config/i3"
    "$DIR"/scripts/i3_ghostty --float -e yay
}

case "$1" in
    check_updates)
        check_updates
        sleep 5m &
        sleep_pid=$!
        wait
        ;;
    install_updates)
        install_updates
        pkill -USR1 --full 'updates_pacman_aur.sh check_updates$'
        ;;
esac
