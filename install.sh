#!/usr/bin/env bash

# Create .config folder if not exists
[[ ! -d "$HOME/.config" ]] && mkdir "$HOME/.config"
CONFIG=$HOME/.config/

##############################
#           ZSH              #
##############################
ln -s "$(pwd)/zsh/zshrc" "$HOME/.zshrc"
source "$(pwd)/zsh/install_ohmyzsh.sh"

##############################
#         ASTRONVIM          #
##############################
ln -s "$(pwd)/nvim" "$CONFIG/nvim"

##############################
#     ASTRONVIM CONFIG       #
##############################
ln -s "$(pwd)/astronvim" "$CONFIG/astronvim"

##############################
#          LAZYGIT           #
##############################
ln -s "$(pwd)/lazygit" "$CONFIG/lazygit"

##############################
#          WEZTERM           #
##############################
ls -s "$(pwd)/wezterm" "$CONFIG/wezterm"

##############################
#           TMUX             #
##############################
ls -s "$(pwd)/tmux" "$CONFIG/tmux"
