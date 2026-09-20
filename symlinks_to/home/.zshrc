export KEYTIMEOUT=1

# XDG base directories.
#
# $HOME/.config is already the spec's default when this is unset, so this
# changes nothing for tools that follow the spec. It matters for the ones that
# deviate on macOS: they use ~/Library/Application Support unless
# XDG_CONFIG_HOME is set explicitly. lazygit is the current example.
#
# This lives here rather than in .zprofile because .zprofile only runs for
# LOGIN shells, which left the variable unset in herdr panes, editor terminals
# and anything else that starts a non-login shell. .zshrc covers every
# interactive shell, which is every context a TUI is ever launched from.
# Non-interactive shells still miss it; nothing here needs it there.
export XDG_CONFIG_HOME="$HOME/.config"

# Must be sourced first — see omz.zsh for why order matters
source ~/.config/zsh/omz.zsh

# Load zsh config modules
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/fzf.zsh
source ~/.config/zsh/pkg_update.zsh
source ~/.config/zsh/vi_mode.zsh

# Local machine-specific overrides (not tracked in dotfiles)
source ~/.config/zsh/.localrc

# Tool initialisations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# Load uv env script if installed via official installer (not needed for Homebrew installs)
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
eval "$(uv generate-shell-completion zsh)"
# Docker CLI completions (fpath must be set after oh-my-zsh)
fpath=($HOME/.docker/completions $fpath)
# disable auto update for claude, used homebrew to update
export DISABLE_AUTOUPDATER=1

# Update the daily package update file (used by pkg_update.zsh)
pkg_update_daily

# Clear the terminal and show system info after loading the config
clear
fastfetch
