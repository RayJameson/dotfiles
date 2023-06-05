#!/usr/bin/env zsh

ZSH_CUSTOM="$DOTFILES/zsh/oh-my-zsh/custom"

install_plugin()
{
    local plugin_repo=$1
    local plugin_name=${plugin_repo##*/}
    local git_url="https://github.com/$1"
    local custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    if [[ -d "$custom_plugins_dir/$plugin_name" ]] && ! grep -q "$plugin_name" <<< "${plugins}"; then
        plugins+=($plugin_name)
    else
        echo -n "Downloading new plugin: $plugin_name"
        git clone --quiet --depth=1 "$git_url" "$custom_plugins_dir/$plugin_name"
        echo -e "\tDone"
        plugins+=($plugin_name)
    fi
}

for plugin in ${custom_plugins}; do
    install_plugin $plugin
done
unset plugin
unset ZSH_CUSTOM
