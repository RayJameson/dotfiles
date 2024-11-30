#!/usr/bin/env zsh

command_exists () {
    if [[ -n $(echo $commands["$@"]) ]]; then
        return 0
    else
        return 1
    fi
}
