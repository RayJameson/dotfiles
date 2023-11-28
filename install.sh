#!/usr/bin/env bash

# Create .config folder if not exists
if [[ ! -d "$HOME/.config" ]]; then
    mkdir "$HOME/.config"
else
    echo "\"$HOME/.config\" already exists, skipping"
fi
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
#           VI(M)            #
##############################
ln -s "$(pwd)/vi-m/.vimrc" "$HOME"

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
ln -s "$(pwd)/fkill" "$HOME"
ln -s "$(pwd)/frg" "$HOME"

##############################
#           LUAJ             #
##############################
ln -s "$(pwd)/luaj-jse-3.0.2.jar" "$HOME"
ln -s "$(pwd)/luaj" "$HOME"

##############################
#         PTPYTHON           #
##############################
ln -s "$(pwd)/ptpython" "$CONFIG"

##############################
#          PYLINT            #
##############################
ln -s "$(pwd)/pylintrc" "$CONFIG"

##############################
#            NVM             #
##############################
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
else
    echo "nvm already installed, skipping"
fi

##############################
#           PYENV            #
##############################
curl https://pyenv.run | bash
ln -s "$(pwd)/pyenv/default-packages" "$HOME/.pyenv/"

##############################
#            GIT             #
##############################
ln -s "$(pwd)/git/.gitconfig" "$HOME"
ln -s "$(pwd)/git/.gitignore_global" "$HOME"

##############################
#            ARC             #
##############################
ln -s "$(pwd)/open_little_arc" "$HOME"
