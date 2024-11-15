alias lvim="NVIM_APPNAME=lvim nvim"
alias help="nocorrect run-help"
alias v="nvim"
alias ng="nvim -c 'Neogit'"
alias v4="NVIM_APPNAME=v4 nvim"
alias venv="source .venv/bin/activate"
alias watch="watch -cd"
[[ $(command -v chezmoi) ]] && alias cz=chezmoi
[[ $(command -v ggrep) ]] && alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
# make functions for commands which could be used in piping
if [[ $(command -v eza) ]]; then
    alias l="eza --long --icons --header --octal-permissions --all --sort name --git --group-directories-first"
    alias lr="eza --long --icons --header --octal-permissions --all --sort name --git --group-directories-first --total-size"
    alias ls="eza --icons --sort name --group-directories-first --git"
    alias lo="eza --icons --sort name -1"
    alias tree="eza --icons --header --sort name --group-directories-first --tree --ignore-glob __pycache__"
    export FZF_ALT_C_OPTS="--preview 'eza --icons --header --sort name --group-directories-first --tree {}'"
fi
if [[ $(command -v python3) ]]; then
    alias p="python"
    alias p3="python3"
fi
[[ $(command -v keepassxc-cli) ]] && alias kp="keepassxc-cli"
[[ -n "$TMUX" ]] && alias clear="clear && tmux clear-history"
alias lg=lazygit
alias lzd=lazydocker
alias c=clear
alias pydoc="python3 -m pydoc"
alias zshrc="$EDITOR $HOME/.zshrc"
[[ $(command -v asciinema) ]] && alias asc=asciinema
if [[ $(command -v zoxide) ]]; then
    eval "$(zoxide init zsh)"
    alias cd="z"
    alias cdi="zi"
fi
