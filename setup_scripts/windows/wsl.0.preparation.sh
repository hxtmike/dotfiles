#!/bin/bash

sudo apt update && sudo apt upgrade

# check if zsh have been installed
if ! command -v zsh &>/dev/null; then
    sudo apt install -y zsh
fi

# check if system default shell is zsh
if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s $(which zsh)
fi
