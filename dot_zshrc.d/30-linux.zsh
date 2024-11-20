if [[ ! $(uname) == "Linux" ]]; then
    return
fi
function zvm_after_init() {
    if command_exists fzf; then
        source <(fzf --zsh)
    fi
}
export SUDO_ASKPASS="$HOME/.config/i3/scripts/rofi_askpass"
alias sudo='sudo -A'
alias lrun='systemd-run --user --scope --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'
alias lrunbg='systemd-run --user --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'

command_exists stderred && export LD_PRELOAD="/usr/\$LIB/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
