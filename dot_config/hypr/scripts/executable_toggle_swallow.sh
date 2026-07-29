#!/usr/bin/env bash

media="$HOME/.local/share/chezmoi/.assets"
notify="notify-send -u low -i $media/hyprland_logo.png -h string:wayland-notify-tag:hyprland-swallow"

swallow_state=$(hyprctl getoption misc:enable_swallow | awk 'NR==1{print $2}')
if [[ $swallow_state -eq 0 ]]; then
    hyprctl dispatch 'hl.config({misc={enable_swallow=true}})'
    $notify "Enabled swallow"
else
    hyprctl dispatch 'hl.config({misc={enable_swallow=false}})'
    $notify "Disabled swallow"
fi
