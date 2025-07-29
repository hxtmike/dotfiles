#!/bin/zsh

# create symlinks for those files
if [ ! -d "$HOME/Library/Application Support/Code/User/" ]; then
    mkdir -p "$HOME/Library/Application Support/Code/User/"
fi

BASEDIR="$(cd "$(dirname "$0")" && cd ../.. && pwd)/symlinks_to"

typeset -A dirs_to_repos
dirs_to_repos=(
    ["$HOME/.profile"]="home/.profile"
    ["$HOME/.zsh"]="home/.zsh"
    ["$HOME/.zshrc"]="home/.zshrc"
    ["$HOME/.zprofile"]="home/.zprofile"
    ["$HOME/.p10k.zsh"]="home/.p10k.zsh"
    ["$HOME/.vimrc"]="home/.vimrc"

    ["$HOME/.config/direnv/direnv.toml"]=".config/direnv/direnv.toml"
    ["$HOME/.config/tmux/tmux.conf"]=".config/tmux/tmux.conf"

    ["$HOME/Library/Application Support/Code/User/settings.json"]="vscode/settings.json"
    ["$HOME/Library/Application Support/Code/User/keybindings.json"]="vscode/keybindings.json"
)

for dir repo in ${(kv)dirs_to_repos}; do
	# echo ${BASEDIR} $repo $dir
    if  [ -f "$dir" ] || [ -L "$dir" ];then
        rm -rf "$dir"
        echo "Removed $dir"
    fi
    ln -s "${BASEDIR}"/"$repo" "$dir"
done

# create localrc file
if [ ! -f ~/.localrc ]; then
    touch ~/.localrc
fi

# macos setting
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false # press and hold disable
