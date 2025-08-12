# Why I'm sourcing envs from this file and not from .zshenv:
# https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
# TLDR: it can cause problems because MacOS has `path_helper` which reorders PATH entries
# Also I source this file from .zprofile for GUI applications.
# On MacOS zprofile is read every interactive shell login, so I put sourcing behind condition
# [[ -n "$TTY" ]] && return

export LOCAL_BIN="$HOME/.local/bin"
export LOCAL_LIB="$HOME/.local/lib"
export XDG_CONFIG_HOME="$HOME/.config"
export CONFIG="$XDG_CONFIG_HOME"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export DOTFILES="$HOME/dotfiles"
export EDITOR=nvim
export PAGER=bat
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
export FZF_TMUX_OPTS="-p80%,60%"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND -t=f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND -t=d"
export FZF_PROMPT_SYMBOL=$([[ -n $NERD_FONT ]] && echo "❯ " ||  echo "> ")
export FZF_DEFAULT_OPTS="--ansi --bind ctrl-u:preview-up,ctrl-d:preview-down --bind ctrl-j:down,ctrl-k:up --no-multi --prompt '$FZF_PROMPT_SYMBOL ' --marker ⇒ --pointer  --reverse --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --preview-window 'down,50%,border-rounded,+{2}+3/3,~3'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | clipcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
# Add colors to Terminal
export LSCOLORS=ExFxBxDxCxegedabagacad
[[ -f "$XDG_CONFIG_HOME/ptpython/config.py" ]] && export PYTHONSTARTUP="$XDG_CONFIG_HOME/ptpython/config.py"

PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:" # default stuff
PATH="$HOME:$LOCAL_BIN:$HOME/go/bin:$HOME/.cargo/bin:$XDG_CONFIG_HOME/emacs/bin:$PATH"
PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
PATH="$HOME/.kube:$PATH"
PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
PATH="$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH"

# remove duplicate entries from $PATH
# zsh uses $path array along with $PATH 
typeset -U PATH path
export PATH
