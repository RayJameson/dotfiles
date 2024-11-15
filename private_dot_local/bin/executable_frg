#!/usr/bin/env bash

# Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
rm -f /tmp/rg-fzf-{r,f}
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
: | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(ripgrep$FZF_PROMPT_SYMBOL)+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(fzf$FZF_PROMPT_SYMBOL)+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --prompt "ripgrep$FZF_PROMPT_SYMBOL" \
    --delimiter : \
    --header 'CTRL-T: Switch between ripgrep/fzf' \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'down,50%,border-rounded,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})'
