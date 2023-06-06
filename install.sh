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
ln -s "$(pwd)/nvim" "$CONFIG"

##############################
#     ASTRONVIM CONFIG       #
##############################
ln -s "$(pwd)/astronvim" "$CONFIG"

##############################
#          LAZYGIT           #
##############################
ln -s "$(pwd)/lazygit" "$CONFIG"

##############################
#          WEZTERM           #
##############################
ln -s "$(pwd)/wezterm" "$CONFIG"

##############################
#           TMUX             #
##############################
python3 -m pip install --upgrade libtmux
ln -s "$(pwd)/tmux" "$CONFIG"

##############################
#        FZF-UTILITIES       #
##############################
ln -s "$(pwd)/ff" "$HOME"
ln -s "$(pwd)/fkill" "$HOME"
ln -s "$(pwd)/frg" "$HOME"

##############################
#           LUAJ             #
##############################
ln -s "$(pwd)/luaj-jse-3.0.2.jar" "$HOME"
ln -s "$(pwd)/luaj" "$HOME"
