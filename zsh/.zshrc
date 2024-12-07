# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    docker
    gh
    extract
    gnu-utils
    gpg-agent
)
custom_plugins=(
    davidde/git
    jeffreytse/zsh-vi-mode
    zdharma-continuum/fast-syntax-highlighting
    Aloxaf/fzf-tab
)
function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
    ZVM_TERM=xterm-256color
    ZVM_VI_EDITOR="nvim -c 'set ft=sh'"
}
for file in "$HOME"/.zshrc.d/*(.); do
    source $file
done
export ZSH="$HOME/.oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"

if [[ $(command -v fd) ]] || [[ $(command -v fdfind) ]] || [[ $(command -v fd-find) ]]; then
    export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix --hidden --follow --exclude .git'
    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
if [[ $(command -v pipx) ]]; then
    eval "$(register-python-argcomplete pipx)"
fi

if [[ $(command -v mise) ]]; then
    eval "$(mise activate zsh)"
fi
