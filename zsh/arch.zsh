function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    if [[ $(command -v fzf) ]]; then
        source <(fzf --zsh)
    fi
}
