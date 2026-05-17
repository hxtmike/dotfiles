#!/bin/zsh

# related to homebrew/macOS
# Homebrew env has to be loaded before others
if [[ $(uname) == "Darwin" ]]; then
    # Run the Homebrew shellenv command
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Homebrew related configuration
    export "C_INCLUDE_PATH=/usr/local/include"
    export "LIBRARY_PATH=/usr/local/lib"
fi

# uv installs tool executables (e.g. ruff, pytest) here
export PATH="$HOME/.local/bin:$PATH"
