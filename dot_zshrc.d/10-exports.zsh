export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
# Add colors to Terminal
export LSCOLORS=ExFxBxDxCxegedabagacad
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
if [[ $(command -v gpg) ]]; then
    export GPG_TTY="$TTY"
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
fi
export DOTFILES="$HOME/dotfiles"
export ZSH_DOTFILES="$DOTFILES/zsh"
