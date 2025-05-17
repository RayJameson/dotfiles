#!/usr/bin/env bash

cursorpos=$(hyprctl cursorpos | tr --delete ',')
x=$(echo "$cursorpos" | cut -d ' ' -f1)
y=$(echo "$cursorpos" | cut -d ' ' -f2)
desired_x=$(( x - 50 ))
desired_y=$(( y - 45 ))
desired_pos="$desired_x $desired_y"

hyprctl keyword windowrule "move $desired_pos, class:^com.github.hluk.copyq$"
hyprctl dispatch exec copyq toggle
