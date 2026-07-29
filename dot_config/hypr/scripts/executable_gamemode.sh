#!/usr/bin/env sh

media="$HOME/.local/share/chezmoi/.assets"
notify="notify-send -u low -i $media/hyprland_logo.png -h string:wayland-notify-tag:hyprland-gamemode"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl dispatch 'hl.config({animations={enabled=false}})'
    hyprctl dispatch 'hl.config({decoration={shadow={enabled=false}, blur={enabled=false}, rounding=0}})'
    hyprctl dispatch 'hl.config({general={gaps_in=0, gaps_out=0, border_size=1}})'
    $notify "Decorations disabled"
    exit
fi
hyprctl reload
$notify "Decorations enabled"
