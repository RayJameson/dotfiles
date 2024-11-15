if [[ ! $(uname) == "Linux" ]]; then
    return
fi
function zvm_after_init() {
    if [[ $(command -v fzf) ]]; then
        source <(fzf --zsh)
    fi
}

[[ $(command -v stderred) ]] && export LD_PRELOAD="/usr/\$LIB/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
