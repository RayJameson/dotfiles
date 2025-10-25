fpath+=~/.zfunc
compinit
zstyle ':completion:*' completer _expand_alias _complete _ignored
# zstyle ':completion:*' regular true
# # disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:*' fzf-flags --bind=ctrl-u:preview-up,ctrl-d:preview-down --bind=ctrl-j:down,ctrl-k:up --no-multi --prompt="$FZF_PROMPT_SYMBOL " --marker=⇒ --pointer= --reverse --color=dark \
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f \
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7 \
  --gutter=' '

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:zi:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:cd:*' popup-min-size 80 12
zstyle ':fzf-tab:complete:z:*' popup-min-size 80 12
zstyle ':fzf-tab:complete:zi:*' popup-min-size 80 12
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
