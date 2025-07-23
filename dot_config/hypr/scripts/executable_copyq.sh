#!/usr/bin/env bash

cursorpos=$(hyprctl cursorpos -j)
x=$(echo "$cursorpos" | jq '.x')
y=$(echo "$cursorpos" | jq '.y')

desired_x=$(( x - 50 ))
desired_y=$(( y - 45 ))

active_monitor=$(hyprctl monitors -j | jq -r 'map(select(.focused == true))')
active_monitor_width="$(echo "$active_monitor" | jq -r '.[].width')"
active_monitor_height="$(echo "$active_monitor" | jq -r '.[].height')"

copyq_x_size=672
copyq_y_size=702

if [[ $(( desired_x + copyq_x_size )) -gt active_monitor_width ]]; then
    desired_x=$(( active_monitor_width - copyq_x_size ))
elif [[ $(( desired_x + copyq_x_size )) -lt active_monitor_width ]]; then
    desired_x=$x
fi

if [[ $(( desired_y + copyq_y_size )) -gt active_monitor_height ]]; then
    desired_y=$(( active_monitor_height - copyq_y_size ))
elif [[ $(( desired_y + copyq_y_size )) -lt active_monitor_height ]]; then
    desired_y=$y
fi

desired_pos="$desired_x $desired_y"

hyprctl keyword windowrule "move $desired_pos, class:^com.github.hluk.copyq$"
hyprctl dispatch exec copyq toggle
