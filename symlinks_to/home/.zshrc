export KEYTIMEOUT=1

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
