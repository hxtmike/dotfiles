#!/bin/zsh
BASEDIR="$(cd "$(dirname "$0")" && cd ../.. && pwd)/symlinks_to"

typeset -A dirs_to_repos
dirs_to_repos=(
    ["$HOME/.profile"]="home/.profile"
    ["$HOME/.zsh"]="home/.zsh"
    ["$HOME/.zshrc"]="home/.zshrc"
    ["$HOME/.zprofile"]="home/.zprofile"
    ["$HOME/.p10k.zsh"]="home/.p10k.zsh"
    ["$HOME/.vimrc"]="home/.vimrc"

    ["$HOME/.config/direnv"]=".config/direnv"
    ["$HOME/.config/tmux"]=".config/tmux"
    ["$HOME/.config/nvim"]=".config/nvim"
)

for dir repo in ${(kv)dirs_to_repos}; do
	echo ${BASEDIR} $repo $dir
    if [ -e "$dir" ] || [ -L "$dir" ]; then
        rm -rf "$dir"
        echo "🗑️Removed $dir"
    fi
    ln -s "${BASEDIR}"/"$repo" "$dir"
    echo "🔗Created symlink for $dir"
done

