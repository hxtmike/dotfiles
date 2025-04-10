# related to homebrew/macOS
# Homebrew env has to be loaded before others
if [[ $(uname) == "Darwin" ]]; then
    # Run the Homebrew shellenv command
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Homebrew related configuration
    export "C_INCLUDE_PATH=/usr/local/include"
    export "LIBRARY_PATH=/usr/local/lib"
fi

# related to pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init --path)"
