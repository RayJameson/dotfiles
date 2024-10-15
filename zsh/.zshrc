# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# If you come from bash you might have to change your $PATH.
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
# Add colors to Terminal
export LSCOLORS=ExFxBxDxCxegedabagacad
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt GLOBDOTS                  # Add hidden files to completion
setopt correct
unsetopt correct_all
ulimit -n 10240
bindkey "[D" backward-word
bindkey "[C" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line
fpath+=~/.zfunc
autoload -Uz compinit bashcompinit; compinit; bashcompinit
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*' regular true

export DOTFILES="$HOME/dotfiles"
export ZSH_DOTFILES="$DOTFILES/zsh"
export OMZ="$ZSH_DOTFILES/oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    docker
    gh
    extract
    gnu-utils
    gpg-agent
)
[[ $(command -v brew) ]] && plugins+=(fzf-brew)
custom_plugins=(
    davidde/git
    jeffreytse/zsh-vi-mode
    zdharma-continuum/fast-syntax-highlighting
    Aloxaf/fzf-tab
)
function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
    ZVM_TERM=xterm-256color
    ZVM_VI_EDITOR="nvim -c 'set ft=sh'"
}
source "$ZSH_DOTFILES/install_custom_plugins.zsh"
source "$OMZ/oh-my-zsh.sh"
if [[ $(uname) == "Darwin" ]]; then
    source "$ZSH_DOTFILES/mac.zsh"
elif [[ $(uname) == "Linux" ]]; then
    source "$ZSH_DOTFILES/arch.zsh"
fi
source "$ZSH_DOTFILES/common_envs.zsh"

source $DOTFILES/detect-clipboard

if [[ $(command -v fd) ]] || [[ $(command -v fdfind) ]] || [[ $(command -v fd-find) ]]; then
    export FZF_DEFAULT_COMMAND='fd --strip-cwd-prefix --hidden --follow --exclude .git'
    # Use fd (https://github.com/sharkdp/fd) instead of the default find
    # command for listing path candidates.
    # - The first argument to the function ($1) is the base path to start traversal
    # - See the source code (completion.{bash,zsh}) for the details.
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi
export FZF_TMUX_OPTS="-p80%,60% --color=dark --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND -t=f -t=d"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND -t=d"
export FZF_PROMPT_SYMBOL=$([[ -n $NERD_FONT ]] && echo "❯ " ||  echo "> ")
export FZF_DEFAULT_OPTS="--bind ctrl-u:preview-up,ctrl-d:preview-down --bind ctrl-j:down,ctrl-k:up --no-multi --prompt '$FZF_PROMPT_SYMBOL ' --marker ⇒ --pointer  --reverse --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --preview-window 'down,50%,border-rounded,+{2}+3/3,~3'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | clipcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export PATH="$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

alias lvim="NVIM_APPNAME=lvim nvim"
alias help="nocorrect run-help"
alias v="nvim"
alias ng="nvim -c 'Neogit'"
alias v4="NVIM_APPNAME=v4 nvim"
alias venv="source .venv/bin/activate"
[[ $(command -v ggrep) ]] && alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
# make functions for commands which could be used in piping
if [[ $(command -v eza) ]]; then
    alias l="eza --long --icons --header --octal-permissions --all --sort name --git --group-directories-first"
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
tm() {
    local session_name=${1:-"main"}
    tmux new -A -s $session_name
}
alias pydoc="python3 -m pydoc"

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
luaj() {
    java -cp "$HOME/luaj-jse-3.0.2.jar" lua $1
}
cdl() {
    cd "$(readlink $1)"
}
ce() {
    cargo --explain $1
}
alias zshrc="$EDITOR $ZSHRC"
[[ $(command -v asciinema) ]] && alias asc=asciinema

# You may need to manually set your language environment


if [[ $(command -v zoxide) ]]; then
    eval "$(zoxide init zsh)"
    alias cd="z"
    alias cdi="zi"
fi
if [[ $(command -v pipx) ]]; then
    eval "$(register-python-argcomplete pipx)"
fi
if [[ $(command -v gpg) ]]; then
    export GPG_TTY="$TTY"
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
fi

if [[ $OSTYPE == "darwin"* ]] && [[ -d "$HOME/.terminfo" ]]; then
    export TERMINFO="$HOME/.terminfo" # this saves your santity on MacOS if you are using TMUX
fi

nvm_init() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
alias_source() {
    zsh -ixc : 2>&1 | grep $1
}
if [[ $(command -v mise) ]]; then
    eval "$(mise activate zsh)"
fi
