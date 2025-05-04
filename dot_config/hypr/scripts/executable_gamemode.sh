#!/usr/bin/env sh

notify='notify-send -u low -h string:wayland-notify-tag:hyprland-gamemode'

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    $notify "Decorations disabled"
    exit
fi
hyprctl reload
$notify "Decorations enabled"
