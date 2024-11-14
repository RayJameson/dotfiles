#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Create .config folder if not exists
LOCAL_BIN="$HOME/.local/bin"
LOCAL_LIB="$HOME/.local/lib"
CONFIG="$HOME/.config"
[[ ! -d "$CONFIG" ]] && mkdir "$CONFIG"
[[ ! -d "$LOCAL_BIN" ]] && mkdir -p "$LOCAL_BIN"
[[ ! -d "$LOCAL_LIB" ]] && mkdir -p "$LOCAL_LIB"
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [[ ! $(command -v git) ]]; then
    printf "\nGit is not installed, please install it\n"
    exit 1
fi

_symlink() {
    local src=$1
    local dst=$2
    printf "Force symlinking: %s -> %s \n" "$src" "$dst"
    ln -sf "$src" "$dst"
}

##############################
#         OH-MY-ZSH          #
##############################
if [[ ! -d $ZSH ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    printf "\noh-my-zsh already installed, skipping\n"
fi

##############################
#       POWERLEVEL10K        #
##############################
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    git clone --depth=1 --filter=blob:none https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM"/themes/powerlevel10k
    _symlink "$(pwd)/zsh/.p10k.zsh" "$HOME"
else
    printf "\npowerlevel10k already installed, skipping\n"
fi

##############################
#           ZSH              #
##############################
_symlink "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
_symlink "$(pwd)/zsh/.zprofile" "$HOME/.zprofile"

##############################
#           RDT              #
##############################
if [[ ! $(command -v rdt) ]]; then
    cd rdt && bash ./install.sh "$LOCAL_BIN" && cd - || exit 1
fi

##############################
#           VI(M)            #
##############################
_symlink "$(pwd)/vi-m/.vimrc" "$HOME"
_symlink "$(pwd)/vi-m/.ideavimrc" "$HOME"

##############################
#         ASTRONVIM          #
##############################
_symlink "$(pwd)/nvim" "$CONFIG"

##############################
#     ASTRONVIM CONFIG       #
##############################
_symlink "$(pwd)/nvim" "$CONFIG"

##############################
#          LAZYGIT           #
##############################
_symlink "$(pwd)/lazygit" "$CONFIG"

##############################
#          WEZTERM           #
##############################
_symlink "$(pwd)/wezterm" "$CONFIG"

##############################
#           TMUX             #
##############################
_symlink "$(pwd)/tmux" "$CONFIG"

##############################
#         PTPYTHON           #
##############################
_symlink "$(pwd)/ptpython" "$CONFIG"

##############################
#          PYLINT            #
##############################
_symlink "$(pwd)/pylintrc" "$CONFIG"

##############################
#            NVM             #
##############################
if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
else
    printf "\nnvm already installed, skipping\n"
fi

##############################
#           PYENV            #
##############################
if [[ ! -d "$HOME/.pyenv" ]]; then
curl https://pyenv.run | bash && \
    mkdir "$HOME/.pyenv" && \
    ln -s "$(pwd)/pyenv/default-packages" "$HOME/.pyenv/" && \
    git clone https://github.com/jawshooah/pyenv-default-packages "$(pyenv root)/plugins/pyenv-default-packages"
else
    printf "\npyenv already installed, skipping\n"
fi

##############################
#            GIT             #
##############################
_symlink "$(pwd)/git/.gitconfig" "$HOME"
_symlink "$(pwd)/git/.gitignore_global" "$HOME"


##############################
#         bin & lib          #
##############################
echo "Force symlinking binaries in $(pwd)/bin to $LOCAL_BIN" && ln -sf "$(pwd)"/bin/* "$LOCAL_BIN"
ln -sf "$(pwd)"/bin/* "$LOCAL_BIN"
echo "Force symlinking libraries in $(pwd)/lib to $LOCAL_LIB" && ln -sf "$(pwd)"/lib/* "$LOCAL_LIB"
ln -sf "$(pwd)"/lib/* "$LOCAL_LIB"

##############################
#            Linux           #
##############################
if [[ $(uname) == "Linux" ]]; then
    ##############################
    #           ROFI             #
    ##############################
    _symlink "$(pwd)/rofi" "$CONFIG"

    ##############################
    #             i3             #
    ##############################
    _symlink "$(pwd)/i3" "$CONFIG"
    ##############################
    #           xprofile         #
    ##############################
    _symlink "$(pwd)/xprofile/.xprofile" "$HOME"
    ##############################
    #            rofi            #
    ##############################
    _symlink "$(pwd)/rofi" "$CONFIG"

##############################
#            MacOS           #
##############################
elif [[ $(uname) == "Darwin" ]]; then
    ##############################
    #         AEROSPACE          #
    ##############################
    _symlink "$(pwd)/aerospace" "$CONFIG"
fi
