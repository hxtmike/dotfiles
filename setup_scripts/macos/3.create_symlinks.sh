#!/bin/zsh
# Creates symlinks from dotfiles repo (symlinks_to/) to their expected system locations.
# Safe to re-run: existing files/symlinks at the target path are removed before re-linking.

# Directories that must exist before symlinking (parent dirs for individual file symlinks)
dirs_to_create=(
    "$HOME/Library/Application Support/Code/User"
    "$HOME/.config/cspell"
    "$HOME/.config/zsh"
    "$HOME/.config/herdr"
    "$HOME/.config/tabiew"
    "$HOME/.config/git"
    "$HOME/.config/lazygit"
    "$HOME/.claude/hooks"
    "$HOME/.codex"
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
    ["$HOME/.zshenv"]="home/.zshenv"
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

    # tabiew — link only config.toml; tabiew rewrites it when settings change
    # from the command palette (writes go through the link)
    ["$HOME/.config/tabiew/config.toml"]=".config/tabiew/config.toml"

    # delta reads all its options from git config, so its settings live in a
    # gitconfig-syntax file included from ~/.gitconfig, which is not tracked here
    # because it carries per-machine identity
    ["$HOME/.config/git/delta.gitconfig"]=".config/git/delta.gitconfig"

    # lazygit ignores git's core.pager, so delta has to be wired up again in
    # lazygit's own config. Only the .config path is linked: lazygit falls back
    # to ~/Library/Application Support when XDG_CONFIG_HOME is unset, but
    # .zshrc sets it for every interactive shell, and a TUI is never launched
    # from anything else.
    ["$HOME/.config/lazygit/config.yml"]=".config/lazygit/config.yml"

    # Zsh config modules
    ["$HOME/.config/zsh/omz.zsh"]=".config/zsh/omz.zsh"
    ["$HOME/.config/zsh/aliases.zsh"]=".config/zsh/aliases.zsh"
    ["$HOME/.config/zsh/functions.zsh"]=".config/zsh/functions.zsh"
    ["$HOME/.config/zsh/fzf.zsh"]=".config/zsh/fzf.zsh"
    ["$HOME/.config/zsh/run_every.zsh"]=".config/zsh/run_every.zsh"
    ["$HOME/.config/zsh/pkg_update.zsh"]=".config/zsh/pkg_update.zsh"
    ["$HOME/.config/zsh/vi_mode.zsh"]=".config/zsh/vi_mode.zsh"

    # Ghostty terminal. Only the XDG dir is linked; the legacy
    # ~/Library/Application Support/com.mitchellh.ghostty/config path used to be
    # linked as well, but Ghostty reads ~/.config/ghostty on its own.
    ["$HOME/.config/ghostty"]=".config/ghostty"

    # Claude Code
    ["$HOME/.claude/CLAUDE.md"]=".claude/CLAUDE.md"
    ["$HOME/.claude/statusline-command.sh"]=".claude/statusline-command.sh"

    # .claude/settings.json is deliberately NOT linked, and the mapping must not
    # be added back. Claude Code rewrites the live settings file at runtime with
    # machine-local state, so the live file is linked from elsewhere; re-adding
    # the mapping here would make whichever setup script runs last win and
    # silently replace those settings with this copy.
    #
    # What is tracked here is the shareable template the live file is seeded
    # from. Portable settings — hooks, statusLine, generic permissions — belong
    # in it and should be kept in step with the live file. It uses ~ paths by
    # design, so do not "fix" them to absolute ones.

    # herdr integration hook for Claude Code — link the single file, not the
    # hooks/ dir, so unmanaged hooks can sit beside it (herdr overwrites this
    # file on `herdr integration install claude`, which writes through the link)
    ["$HOME/.claude/hooks/herdr-agent-state.sh"]=".claude/hooks/herdr-agent-state.sh"

    # Flags the session while Claude is waiting on a scheduled wake-up or a
    # poll, so the status line can keep Herdr's status icon on "working" rather
    # than idle (see the script header). Ours, not herdr's, so it is safe from
    # `herdr integration install claude`.
    ["$HOME/.claude/hooks/claude-monitoring-flag.sh"]=".claude/hooks/claude-monitoring-flag.sh"

    # Codex — same working rules as Claude Code, so point AGENTS.md at CLAUDE.md
    # rather than keeping a second copy that drifts
    ["$HOME/.codex/AGENTS.md"]=".claude/CLAUDE.md"

    # herdr integration hook for Codex — a genuinely different script from the
    # Claude one (different hook payload fields, CODEX_THREAD_ID check), so it
    # gets its own file rather than sharing. Note the path has no hooks/ dir:
    # `herdr integration install codex` expects it directly under ~/.codex.
    ["$HOME/.codex/herdr-agent-state.sh"]=".codex/herdr-agent-state.sh"

    # Codex's config.toml and hooks.json are NOT here — both embed absolute
    # $HOME paths, and config.toml also accumulates per-project trust entries as
    # Codex is used. They are linked from elsewhere, for the same reason as
    # .claude/settings.json above.

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

# Codex skills: same SKILL.md format as Claude Code, so share the same sources.
# Link per-skill for the same reason as above, and additionally to avoid
# clobbering ~/.codex/skills/.system (Codex's own bundled skills).
codex_skills_dir="$HOME/.codex/skills"
if [ -L "$codex_skills_dir" ]; then
    rm "$codex_skills_dir"
    echo "🗑️ Removed folder symlink $codex_skills_dir"
fi
mkdir -p "$codex_skills_dir"
for skill in "${BASEDIR}"/.claude/skills/*(/N); do
    target="$codex_skills_dir/${skill:t}"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
        echo "🗑️ Removed $target"
    fi
    ln -s "$skill" "$target"
    echo "🔗  Created symlink for $target \n"
done

# create zshrc.local file
if [ ! -f ~/.config/zsh/.zshrc.local ]; then
    touch ~/.config/zsh/.zshrc.local
fi

# create zshenv.local file
if [ ! -f ~/.config/zsh/.zshenv.local ]; then
    touch ~/.config/zsh/.zshenv.local
fi
