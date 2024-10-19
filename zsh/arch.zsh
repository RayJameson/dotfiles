function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    if [[ $(command -v fzf) ]]; then
        source <(fzf --zsh)
    fi
}

[[ $(command -v stderred) ]] && export LD_PRELOAD="/usr/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
