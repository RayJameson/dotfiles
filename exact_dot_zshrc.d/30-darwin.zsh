if [[ ! $(uname) == "Darwin" ]]; then
    return
fi
if (( $+commands[ggrep] )); then
alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
fi
if (( $+commands[gman] )); then
alias man='gman -L ru.UTF-8'
fi
alias xdg-open=open
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'
# shims instead of `mise activate`: its per-prompt hook is slow under Defender
path=("$XDG_DATA_HOME/mise/shims" $path)
