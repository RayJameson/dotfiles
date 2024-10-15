#!/usr/bin/env bash

# Create .config folder if not exists
if [[ ! -d "$HOME/.config" ]]; then
    mkdir "$HOME/.config"
else
    echo "\"$HOME/.config\" already exists, skipping"
fi
CONFIG="$HOME/.config"

if [[ ! $(command -v git) ]]; then
    echo "Git is not installed, please install it"
    exit 1
fi
##############################
#           ZSH              #
##############################
ln -s "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
ln -s "$(pwd)/zsh/.zprofile" "$HOME/.zprofile"

##############################
#       POWERLEVEL10K        #
##############################
ln -s "$(pwd)/zsh/powerlevel10k" "$(pwd)/zsh/oh-my-zsh/custom/themes"

##############################
#           VI(M)            #
##############################
ln -s "$(pwd)/vi-m/.vimrc" "$HOME"
ln -s "$(pwd)/vi-m/.ideavimrc" "$HOME"

##############################
#         ASTRONVIM          #
##############################
ln -s "$(pwd)/nvim" "$CONFIG"

##############################
#     ASTRONVIM CONFIG       #
##############################
ln -s "$(pwd)/nvim" "$CONFIG"

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
curl https://pyenv.run | bash && ln -s "$(pwd)/pyenv/default-packages" "$HOME/.pyenv/"

##############################
#            GIT             #
##############################
ln -s "$(pwd)/git/.gitconfig" "$HOME"
ln -s "$(pwd)/git/.gitignore_global" "$HOME"

##############################
#           ROFI             #
##############################
if [[ $(uname) == "Linux" ]]; then
    git clone --depth=1 --filter=blob:none https://github.com/adi1090x/rofi.git && \
        cd rofi && \
        chmod +x ./setup.sh && \
        ./setup.sh && \
        cd .. && \
        rm -rfi rofi

    git clone --depth=1 --filter=blob:none https://github.com/lr-tech/rofi-themes-collection.git && \
        mv rofi-themes-collection/themes "$HOME/.config/rofi" && \
        cd .. && \
        rm -rfi rofi-themes-collection
##############################
#             i3             #
##############################
ln -s "$(pwd)/i3" "$CONFIG"
fi



