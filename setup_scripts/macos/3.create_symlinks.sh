#!/bin/zsh
# Creates symlinks from dotfiles repo (symlinks_to/) to their expected system locations.
# Safe to re-run: existing files/symlinks at the target path are removed before re-linking.

# Directories that must exist before symlinking (parent dirs for individual file symlinks)
dirs_to_create=(
    "$HOME/Library/Application Support/Code/User"
    "$HOME/.config/cspell"
    "$HOME/.config/zsh"
    "$HOME/.config/herdr"
    "$HOME/.claude/hooks"
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

    # herdr — link only config.toml; the rest of ~/.config/herdr is runtime state
    # (sockets, logs, session.json, release-notes.json) that must stay local
    ["$HOME/.config/herdr/config.toml"]=".config/herdr/config.toml"

    # VisiData ignores XDG on macOS, so link the config to the legacy fallback
    # path it always reads regardless of shell/env (no VD_CONFIG dependency)
    ["$HOME/.visidatarc"]="home/.visidatarc"

    # Zsh config modules
    ["$HOME/.config/zsh/omz.zsh"]=".config/zsh/omz.zsh"
    ["$HOME/.config/zsh/aliases.zsh"]=".config/zsh/aliases.zsh"
    ["$HOME/.config/zsh/functions.zsh"]=".config/zsh/functions.zsh"
    ["$HOME/.config/zsh/fzf.zsh"]=".config/zsh/fzf.zsh"
    ["$HOME/.config/zsh/pkg_update.zsh"]=".config/zsh/pkg_update.zsh"
    ["$HOME/.config/zsh/vi_mode.zsh"]=".config/zsh/vi_mode.zsh"

    # Ghostty terminal — requires both the XDG config dir and the legacy app support path
    ["$HOME/.config/ghostty"]=".config/ghostty"
    ["$HOME/Library/Application Support/com.mitchellh.ghostty/config"]=".config/ghostty/config"

    # Claude Code
    ["$HOME/.claude/CLAUDE.md"]=".claude/CLAUDE.md"
    ["$HOME/.claude/settings.json"]=".claude/settings.json"
    ["$HOME/.claude/statusline-command.sh"]=".claude/statusline-command.sh"

    # herdr integration hook for Claude Code — link the single file, not the
    # hooks/ dir, so unmanaged hooks can sit beside it (herdr overwrites this
    # file on `herdr integration install claude`, which writes through the link)
    ["$HOME/.claude/hooks/herdr-agent-state.sh"]=".claude/hooks/herdr-agent-state.sh"

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

# Claude Code skills: link each skill individually so other (non-repo) skills
# under ~/.claude/skills are left untouched. ~/.claude/skills must be a real
# directory, not a folder-symlink — otherwise the per-skill links below would
# resolve back into the repo and clobber it.
claude_skills_dir="$HOME/.claude/skills"
if [ -L "$claude_skills_dir" ]; then
    rm "$claude_skills_dir"
    echo "🗑️ Removed folder symlink $claude_skills_dir"
fi
mkdir -p "$claude_skills_dir"
for skill in "${BASEDIR}"/.claude/skills/*(/N); do
    target="$claude_skills_dir/${skill:t}"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
        echo "🗑️ Removed $target"
    fi
    ln -s "$skill" "$target"
    echo "🔗  Created symlink for $target \n"
done

# create localrc file
if [ ! -f ~/.config/zsh/.localrc ]; then
    touch ~/.config/zsh/.localrc
fi
