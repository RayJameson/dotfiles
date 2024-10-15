# Why I'm sourcing envs from this file and not from .zshenv:
# https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
# TLDR: it can cause problems because MacOS has `path_helper` which reorders PATH entries
# Also I source this file from .zprofile for GUI applications.
# On MacOS zprofile is read every interactive shell login, so I put sourcing behind condition
# [[ -n "$TTY" ]] && return

export LOCAL_BIN="$HOME/.local/bin"
export XDG_CONFIG_HOME="$HOME/.config"
export CONFIG="$XDG_CONFIG_HOME"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export DOTFILES="$HOME/dotfiles"
export EDITOR=nvim
export PAGER=bat
export POETRY_CONFIG_DIR="$XDG_CONFIG_HOME/pypoetry"
export POETRY_DATA_DIR="$XDG_DATA_HOME/pypoetry"
export POETRY_CACHE_DIR="$XDG_CACHE_HOME/pypoetry"
export POETRY_VIRTUALENVS_IN_PROJECT=true
export PYENV_ROOT="$HOME/.pyenv"
[[ -f "$XDG_CONFIG_HOME/ptpython/config.py" ]] && export PYTHONSTARTUP="$XDG_CONFIG_HOME/ptpython/config.py"

PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:" # default stuff
PATH="$HOME:$DOTFILES:$LOCAL_BIN:$HOME/go/bin:$HOME/.cargo/bin:$XDG_CONFIG_HOME/emacs/bin:$PATH"
PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
PATH="$HOME/.kube:$PATH"
PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

export MANPATH="/usr/local/man:$MANPATH"
[[ $(command -v nvim) ]] && export MANPAGER="nvim +Man! $@"

# remove duplicate entries from $PATH
# zsh uses $path array along with $PATH 
typeset -U PATH path
export PATH
