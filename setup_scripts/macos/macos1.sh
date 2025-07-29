#!/bin/zsh

# if apple silicon
if [[ $(uname -p) == "arm" ]]; then
    softwareupdate --install-rosetta
fi

# check and install homebrew
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
    # this is for dependency reason of Homebrew
    sudo mkdir -p /usr/local/include
    sudo mkdir -p /usr/local/lib

    brew update

# for dependency reasons
if ! command -v xz &> /dev/null; then
    brew install xz
fi

# fd, better find
if ! command -v fd &> /dev/null; then
    brew install fd
fi

# ripgrep, better grep
if ! command -v rg &> /dev/null; then
    brew install ripgrep
fi

# btop, better top
if ! command -v btop &> /dev/null; then
    brew install btop
fi

# bat, better cat
if ! command -v bat &> /dev/null; then
    brew install bat
fi

# eza, better ls
if ! command -v eza &> /dev/null; then
    brew install eza
fi

# zoxide, better cd
if ! command -v zoxide &> /dev/null; then
    brew install zoxide
fi

# tmux
if ! command -v tmux &> /dev/null; then
    brew install tmux

fi

# fzf, fuzzy finder
if ! command -v fzf &> /dev/null; then
    brew install fzf
fi

# check and isntall direnv
if ! command -v direnv &> /dev/null; then
    brew install direnv
fi

# uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ruff, python linter
if ! command -v ruff &> /dev/null; then
    sudo uv tool install ruff
fi
