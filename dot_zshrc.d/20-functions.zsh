cdl() {
    cd "$(readlink $1)"
}
ce() {
    cargo --explain $1
}
nvm_init() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
alias_source() {
    zsh -ixc : 2>&1 | grep $1
}
if [[ $(command -v pyenv) ]]; then
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    pyvenv() {
        venv_name=${2:-$(basename $(pwd))}
        pyenv virtualenv $1 $venv_name
        pyenv local $venv_name
    }
    pyenv_init() {
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"

    }
    check_pyenv_init() {
        if [[ -f .python-version ]]; then
            pyenv_init
        fi
    }
    # add check_pyenv_init function to precmd_functions array
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd check_pyenv_init
fi
tm() {
    local session_name=${1:-"main"}
    tmux new -A -s $session_name
}