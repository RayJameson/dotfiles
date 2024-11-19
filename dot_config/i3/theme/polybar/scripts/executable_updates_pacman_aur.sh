#!/bin/sh

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
    "$DIR"/scripts/i3_wezterm --float yay
}

case "$1" in
    check_updates)
        check_updates
        ;;
    install_updates)
        install_updates
        ;;
esac
