# Early exit, because we don't want to source same file twice (zshrc)
# On MacOS zprofile is read every interactive shell login, so I put sourcing behind condition
[[ -n "$TTY" ]] && return

source "$HOME/.zshrc"
if [[ $(command -v gpg) ]]; then
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi
fi
