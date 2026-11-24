if [[ ! $(uname) == "Linux" ]]; then
    return
fi
if [[ -n $DISPLAY ]]; then
    export SUDO_ASKPASS="$CONFIG/i3/scripts/rofi_askpass"
    alias sudo='sudo -A'
    alias sudoedit='sudoedit -A'
fi
alias lrun='systemd-run --user --scope --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'
alias lrunbg='systemd-run --user --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'
alias wm='wikiman'
# Arch package managers
alias pari='paru --color always -Sl --aur | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "paru -Si {1}" --reverse | xargs -ro paru -S'
alias yayi='yay --color always -Sl --aur | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "yay -Si {1}" --reverse | xargs -ro yay -S'
alias paci='pacman --color always -Sl | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "pacman -Si {1}" --reverse | xargs -ro sudo pacman -S'
if (( $+commands[stderred] )); then
export LD_PRELOAD="/usr/\$LIB/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
fi
alias man='man -L ru.UTF-8'
source "$ZSH/plugins/gpg-agent/gpg-agent.plugin.zsh"
if (( $+commands[mise] )); then
eval "$(mise activate zsh)"
check_mise() {
    if [[ -f mise.toml ]]; then
        eval "$(mise activate zsh)"
    fi
}
add-zsh-hook precmd check_mise
fi
