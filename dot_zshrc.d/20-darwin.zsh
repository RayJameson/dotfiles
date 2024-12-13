if [[ ! $(uname) == "Darwin" ]]; then
    return
fi
if [[ $TERM_PROGRAM != ghostty ]] && [[ -d "$HOME/.terminfo" ]]; then
    export TERMINFO="$HOME/.terminfo" # this saves your santity on MacOS if you are using TMUX
fi
export PNPM_HOME="$HOME/Library/pnpm"
if command_exists brew; then
    export HOMEBREW_CASK_OPTS="--no-quarantine"
    export HOMEBREW_AUTO_UPDATING=0
    export HOMEBREW_PREFIX="$(brew --prefix)"
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/curl/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/curl/include"
    PATH="$HOMEBREW_PREFIX/Cellar/pyenv-virtualenv/1.1.5/shims/$HOMEBREW_PREFIX/bin:$PATH"
    PATH="$HOMEBREW_PREFIX/sbin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/man-db/libexec/bin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"
    PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi
PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:/Library/Frameworks/Python.framework/Versions/3.9/bin:/Library/Apple/usr/bin:/usr/local/opt/fzf/bin:$HOME/.gem/ruby/2.6.0/bin:$PNPM_HOME:$ORACLE_HOME:$PATH"
PATH="$PATH:/Users/mik.dmitriev/Library/Application Support/Coursier/bin"
command_exists ggrep && alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
alias xdg-open=open
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'

typeset -U PATH path
export PATH
