#!/bin/zsh
# Creates symlinks from dotfiles repo (symlinks_to/) to their expected system locations.
# Safe to re-run: existing files/symlinks at the target path are removed before re-linking.

# Directories that must exist before symlinking (parent dirs for individual file symlinks)
dirs_to_create=(
    "$HOME/Library/Application Support/Code/User"
    "$HOME/.config/cspell"
    "$HOME/.config/zsh"
)
mkdir -p "${dirs_to_create[@]}"

# Resolve the symlinks_to/ directory relative to this script, regardless of where it's called from
BASEDIR="$(cd "$(dirname "$0")" && cd ../.. && pwd)/symlinks_to"

# Map: system path -> path relative to symlinks_to/
typeset -A dirs_to_repos
dirs_to_repos=(
    # Shell
    ["$HOME/.profile"]="home/.profile"
    ["$HOME/.zsh"]="home/.zsh"
    ["$HOME/.zshrc"]="home/.zshrc"
    ["$HOME/.zprofile"]="home/.zprofile"

    # Vim
    ["$HOME/.vimrc"]="home/.vimrc"
    ["$HOME/.vim"]=".vim"

    # CLI tools
    ["$HOME/.config/direnv"]=".config/direnv"
    ["$HOME/.config/tmux"]=".config/tmux"
    ["$HOME/.config/nvim"]=".config/nvim"
    ["$HOME/.config/starship.toml"]=".config/starship.toml"
    ["$HOME/.config/cspell/universal-dict.txt"]=".config/cspell/universal-dict.txt"

    # Ghostty terminal — requires both the XDG config dir and the legacy app support path
    ["$HOME/.config/ghostty"]=".config/ghostty"
    ["$HOME/Library/Application Support/com.mitchellh.ghostty/config"]=".config/ghostty/config"

    # Claude Code
    ["$HOME/.claude/CLAUDE.md"]=".claude/CLAUDE.md"
    ["$HOME/.claude/settings.json"]=".claude/settings.json"
    ["$HOME/.claude/skills"]=".claude/skills"

    # VS Code
    ["$HOME/Library/Application Support/Code/User/settings.json"]="vscode/settings.json"
    ["$HOME/Library/Application Support/Code/User/keybindings.json"]="vscode/keybindings.json"
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
