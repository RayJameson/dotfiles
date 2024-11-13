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
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$(pwd)/zsh/.zprofile" "$HOME/.zprofile"

##############################
#           RDT              #
##############################
[[ ! -d $LOCAL_BIN ]] && mkdir -p "$HOME/.local/bin"
cd rdt && bash ./install.sh "$LOCAL_BIN" && cd - || exit 1

##############################
#       POWERLEVEL10K        #
##############################
ln -sf "$(pwd)/zsh/powerlevel10k" "$(pwd)/zsh/oh-my-zsh/custom/themes"

##############################
#           VI(M)            #
##############################
ln -sf "$(pwd)/vi-m/.vimrc" "$HOME"
ln -sf "$(pwd)/vi-m/.ideavimrc" "$HOME"

##############################
#         ASTRONVIM          #
##############################
ln -sf "$(pwd)/nvim" "$CONFIG"

##############################
#     ASTRONVIM CONFIG       #
##############################
ln -sf "$(pwd)/nvim" "$CONFIG"

##############################
#          LAZYGIT           #
##############################
ln -sf "$(pwd)/lazygit" "$CONFIG"

##############################
#          WEZTERM           #
##############################
ln -sf "$(pwd)/wezterm" "$CONFIG"

##############################
#           TMUX             #
##############################
ln -sf "$(pwd)/tmux" "$CONFIG"

##############################
#         PTPYTHON           #
##############################
ln -sf "$(pwd)/ptpython" "$CONFIG"

##############################
#          PYLINT            #
##############################
ln -sf "$(pwd)/pylintrc" "$CONFIG"

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
curl https://pyenv.run | bash && \
    mkdir "$HOME/.pyenv" && \
    ln -s "$(pwd)/pyenv/default-packages" "$HOME/.pyenv/" && \
    git clone https://github.com/jawshooah/pyenv-default-packages "$(pyenv root)/plugins/pyenv-default-packages"

##############################
#            GIT             #
##############################
ln -sf "$(pwd)/git/.gitconfig" "$HOME"
ln -sf "$(pwd)/git/.gitignore_global" "$HOME"


##############################
#            Linux           #
##############################
if [[ $(uname) == "Linux" ]]; then
    ##############################
    #           ROFI             #
    ##############################
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
    ln -sf "$(pwd)/i3" "$CONFIG"
    ##############################
    #           xprofile         #
    ##############################
    ln -sf "$(pwd)/xprofile/.xprofile" "$HOME"
    ##############################
    #            rofi            #
    ##############################
    ln -sf "$(pwd)/rofi" "$CONFIG"

##############################
#            MacOS           #
##############################
elif [[ $(uname) == "Darwin" ]]; then
    ##############################
    #         AEROSPACE          #
    ##############################
    ln -sf "$(pwd)/aerospace" "$CONFIG"
fi
