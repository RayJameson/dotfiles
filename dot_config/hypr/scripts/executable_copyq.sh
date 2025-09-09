#!/usr/bin/env bash

cursorpos=$(hyprctl cursorpos -j)
x=$(echo "$cursorpos" | jq '.x')
y=$(echo "$cursorpos" | jq '.y')

desired_x=$(( x - 50 ))
desired_y=$(( y - 45 ))

active_monitor=$(hyprctl monitors -j | jq -r 'map(select(.focused == true)).[]')
active_monitor_width="$(echo "$active_monitor" | jq -r '.width')"
active_monitor_height="$(echo "$active_monitor" | jq -r '.height')"
active_monitor_name=$(echo "$active_monitor" | jq -r '.name')

waybar_properties=$(hyprctl -j layers | jq -r ".\"$active_monitor_name\".levels | map(select(.[].namespace == \"waybar\")) | .[].[]")
waybar_height=$(echo "$waybar_properties" | jq -r '.h')

copyq_width=672
copyq_height=702

if [[ $(( desired_x + copyq_width )) -gt active_monitor_width ]]; then
    desired_x=$(( active_monitor_width - copyq_width ))
elif [[ $(( desired_x + copyq_width )) -lt active_monitor_width ]]; then
    desired_x=$x
fi

if [[ $(( desired_y + copyq_height )) -gt active_monitor_height ]]; then
    desired_y=$(( active_monitor_height - copyq_height ))
elif [[ $(( desired_y )) -lt waybar_height ]]; then
    desired_y=$waybar_height
elif [[ $(( desired_y + copyq_height )) -lt active_monitor_height ]]; then
    desired_y=$y
fi

desired_pos="$desired_x $desired_y"

hyprctl keyword windowrule "move $desired_pos, class:^com.github.hluk.copyq$"
hyprctl dispatch exec copyq toggle
