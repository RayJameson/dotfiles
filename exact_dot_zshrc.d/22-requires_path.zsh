if (( $+commands[gpg] )); then
export GPG_TTY="$TTY"
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
fi

if (( $+commands[nvim] )); then
export MANPAGER="nvim +Man! $@"
fi

if (( $+commands[register-python-argcomplete] )); then
eval "$(register-python-argcomplete pipx)"
fi

export PYENV_ROOT="$HOME/.pyenv"

fd_cmd=${${commands[fd]:+fd}:-${${commands[fdfind]:+fdfind}:-${commands[fd-find]:+fd-find}}}
if [[ -n $fd_cmd ]]; then

export FZF_DEFAULT_COMMAND="$fd_cmd --strip-cwd-prefix --hidden --follow --exclude .git"
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    $fd_cmd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    $fd_cmd --type d --hidden --follow --exclude ".git" . "$1"
}
fi

export POETRY_CONFIG_DIR="$XDG_CONFIG_HOME/pypoetry"
export POETRY_DATA_DIR="$XDG_DATA_HOME/pypoetry"
export POETRY_CACHE_DIR="$XDG_CACHE_HOME/pypoetry"
export POETRY_VIRTUALENVS_IN_PROJECT=true
