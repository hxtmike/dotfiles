# Must be sourced first in .zshrc — these variables must be set before oh-my-zsh initialises.
export ZSH="$HOME/.oh-my-zsh"
HYPHEN_INSENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    direnv
)

source $ZSH/oh-my-zsh.sh
