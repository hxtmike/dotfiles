# macOS setting: Disable press-and-hold for keys (enables key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false # Disable press-and-hold globally
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false # Disable press-and-hold specifically for VS Code

defaults write -g KeyRepeat -int 1
