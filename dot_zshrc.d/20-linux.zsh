if [[ ! $(uname) == "Linux" ]]; then
    return
fi
export SUDO_ASKPASS="$HOME/.config/i3/scripts/rofi_askpass"
alias sudo='sudo -A'
alias sudoedit='sudoedit -A'
alias lrun='systemd-run --user --scope --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'
alias lrunbg='systemd-run --user --property CPUQuota=80% --property MemoryMax=31G --property MemoryHigh=28G'
alias wm='wikiman'
# Arch package managers
command_exists paru && alias pari='paru --color always -Sl --aur | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "paru -Si {1}" --reverse | xargs -ro paru -S'
command_exists yay && alias yayi='yay --color always -Sl --aur | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "yay -Si {1}" --reverse | xargs -ro yay -S'
command_exists pacman && alias paci='pacman --color always -Sl | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "pacman -Si {1}" --reverse | xargs -ro sudo pacman -S'

command_exists stderred && export LD_PRELOAD="/usr/\$LIB/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"