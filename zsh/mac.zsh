function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="opt/homebrew/Cellar/pyenv-virtualenv/1.1.5/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/Library/Frameworks/Python.framework/Versions/3.9/bin:/Library/Apple/usr/bin:/usr/local/opt/fzf/bin:$HOME/.gem/ruby/2.6.0/bin:$PNPM_HOME:$ORACLE_HOME:$PATH"
export PATH="/opt/homebrew/opt/man-db/libexec/bin:/opt/homebrew/opt/gnu-tar/libexec/gnubin:/opt/homebrew/opt/gawk/libexec/gnubin:/opt/homebrew/opt/gnu-which/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$PATH:/Users/mik.dmitriev/Library/Application Support/Coursier/bin"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export HOMEBREW_AUTO_UPDATING=0
alias xdg-open=open
export HOMEBREW_CASK_OPTS="--no-quarantine"
