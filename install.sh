#!/usr/bin/env bash

# Create .config folder if not exists
[[ ! -d "$HOME/.config" ]] && mkdir "$HOME/.config"
CONFIG="$HOME/.config"

##############################
#           ZSH              #
##############################
ln -s "$(pwd)/zsh/zshrc" "$HOME/.zshrc"

##############################
#       POWERLEVEL10K        #
##############################
ln -s "$(pwd)/zsh/powerlevel10k" "$(pwd)/zsh/oh-my-zsh/custom/themes"

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
ln -s "$(pwd)/wezterm" "$CONFIG/wezterm"

##############################
#           TMUX             #
##############################
ln -s "$(pwd)/tmux" "$CONFIG/tmux"
