#!/bin/zsh

# create symlinks for those files
if [ ! -d "$HOME/Library/Application Support/Code/User/" ]; then
    mkdir -p "$HOME/Library/Application Support/Code/User/"
fi

if [ ! -d "$HOME/.config/cspell" ]; then
    mkdir -p "$HOME/.config/cspell/"
fi


BASEDIR="$(cd "$(dirname "$0")" && cd ../.. && pwd)/symlinks_to"

typeset -A dirs_to_repos
dirs_to_repos=(
    ["$HOME/.profile"]="home/.profile"
    ["$HOME/.zsh"]="home/.zsh"
    ["$HOME/.zshrc"]="home/.zshrc"
    ["$HOME/.zprofile"]="home/.zprofile"
    ["$HOME/.vimrc"]="home/.vimrc"
    ["$HOME/.vim"]=".vim"

    ["$HOME/.config/direnv"]=".config/direnv"
    ["$HOME/.config/tmux"]=".config/tmux"
    ["$HOME/.config/nvim"]=".config/nvim"

    ["$HOME/.config/ghostty"]=".config/ghostty"
    ["$HOME/Library/Application Support/com.mitchellh.ghostty/config"]=".config/ghostty/config"

    ["$HOME/.config/starship.toml"]=".config/starship.toml"

    ["$HOME/.claude/CLAUDE.md"]=".claude/CLAUDE.md"
    ["$HOME/.claude/settings.json"]=".claude/settings.json"
    ["$HOME/.claude/skills"]=".claude/skills"

    ["$HOME/Library/Application Support/Code/User/settings.json"]="vscode/settings.json"
    ["$HOME/Library/Application Support/Code/User/keybindings.json"]="vscode/keybindings.json"
    ["$HOME/.config/cspell/universal-dict.txt"]=".config/cspell/universal-dict.txt"
)

for dir repo in ${(kv)dirs_to_repos}; do
	echo ${BASEDIR} $repo $dir
    if [ -e "$dir" ] || [ -L "$dir" ]; then
        rm -rf "$dir"
        echo "🗑️ Removed $dir"
    fi
    ln -s "${BASEDIR}"/"$repo" "$dir"
    echo "🔗  Created symlink for $dir \n"
done
