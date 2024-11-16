if [[ ! $(uname) == "Linux" ]]; then
    return
fi
function zvm_after_init() {
    if command_exists fzf; then
        source <(fzf --zsh)
    fi
}

command_exists stderred && export LD_PRELOAD="/usr/\$LIB/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
