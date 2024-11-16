#!/usr/bin/env zsh

command_exists () {
    command -v "$@" &> /dev/null
}
