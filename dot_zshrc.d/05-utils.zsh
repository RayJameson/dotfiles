#!/usr/bin/env zsh

command_exists () {
    if [[ -n $(command -v "$@") ]]; then
        return 0
    else
        # uncomment for debugging
        # echo "Command doesn't exist \"$*\""
        return 1
    fi
}
