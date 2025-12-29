# create localrc file
if [ ! -f ~/.localrc ]; then
    touch ~/.localrc
fi

# macos setting
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false # press and hold disable
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false   

defaults write -g KeyRepeat -int 1