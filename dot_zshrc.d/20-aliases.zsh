alias lvim="NVIM_APPNAME=lvim nvim"
alias help="nocorrect run-help"
alias v="nvim"
alias ng="nvim -c 'Neogit'"
alias v4="NVIM_APPNAME=v4 nvim"
alias venv="source .venv/bin/activate"
alias watch="watch -cd"
if command_exists chezmoi; then
    alias cz='chezmoi'
    alias czi='chezmoi init'
    alias czs='chezmoi status'
    alias czd='chezmoi diff'
    alias czm='chezmoi merge-all'
    alias czap='chezmoi apply'
    alias cza='chezmoi add'
    alias czra='chezmoi re-add'
    alias czcd='chezmoi cd'
    alias cze='chezmoi edit'
    alias czea='chezmoi edit --apply'
    alias czf='chezmoi forget'
    alias czu='chezmoi update'
fi
command_exists ggrep && alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
# make functions for commands which could be used in piping
if command_exists eza; then
    alias l="eza --long --icons --header --octal-permissions --all --sort name --git --group-directories-first"
    alias lr="eza --long --icons --header --octal-permissions --all --sort name --git --group-directories-first --total-size"
    alias ls="eza --icons --sort name --group-directories-first --git"
    alias lo="eza --icons --sort name -1"
    alias tree="eza --icons --header --sort name --group-directories-first --tree --ignore-glob __pycache__"
    export FZF_ALT_C_OPTS="--preview 'eza --icons --header --sort name --group-directories-first --tree {}'"
fi
if command_exists python3; then
    alias p="python"
    alias p3="python3"
fi
command_exists keepassxc-cli && alias kp="keepassxc-cli"
[[ -n "$TMUX" ]] && alias clear="clear && tmux clear-history"
alias lg=lazygit
alias lzd=lazydocker
alias c=clear
alias pydoc="python3 -m pydoc"
alias zshrc="$EDITOR $HOME/.zshrc"
command_exists asciinema && alias asc=asciinema
if command_exists zoxide; then
    eval "$(zoxide init zsh)"
    alias cd="z"
    alias cdi="zi"
fi

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function
if [ ! $(uname -s) = 'Darwin' ]; then
    if grep -q Microsoft /proc/version; then
        # Ubuntu on Windows using the Linux subsystem
        alias open='explorer.exe';
    else
        alias open='xdg-open';
    fi
fi
# Arch package managers
alias pari='paru --color always -Sl | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "paru -Si {1}" --reverse | xargs -ro paru -S'
alias yayi='yay --color always -Sl | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "yay -Si {1}" --reverse | xargs -ro yay -S'
alias paci='pacman --color always -Sl | awk '\''{print $2($4=="" ? "" : " *")}'\'' | fzf --multi --ansi --preview "pacman -Si {1}" --reverse | xargs -ro sudo pacman -S'
