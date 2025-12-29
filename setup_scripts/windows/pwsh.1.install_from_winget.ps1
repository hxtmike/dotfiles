# assuming below have been installed before running this script
winget install --id Git.Git -e --source winget
winget install --id Microsoft.VisualStudioCode -e --source winget
winget install --id Microsoft.WindowsTerminal -e --source winget

# install cli apps
winget install --id Fastfetch-cli.Fastfetch -e --source winget
winget install --id vim.vim -e --source winget
winget install --id Neovim.Neovim -e --source winget
    ## to be continued: vim/nvim for an example here
    ## for full dev environment setup, please refer similar Brewfile in macOS setup_scripts/mac/ folder
    ## 1. cli commands e.g. winget install --id junegunn.fzf -e --source winget
    ## 2. Symlink to files other than profile/zshrc e.g. vim/nvim
    ## 3. inside more setting in the proflie need to be updated. like .zshrc in macOS
        ## all alias for l, cd, etc
        ## fzf auto-completion setup
        ## all custom functions cl(), etc
        ## auto update from winget # done
        ## fastfetch # done

# install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh --source winget # special

# install gui apps
winget install --id Microsoft.PowerShell -e --source winget # updated this to the latest version
winget install --id Microsoft.PowerToys -e --source winget

winget install --id Google.Chrome -e --source winget

winget install --id DeepL.DeepL -e --source winget
winget install --id Grammarly.Grammarly -e --source winget

winget install --id Tencent.QQ.NT -e --source winget
winget install --id Tencent.WeChat.Universal -e --source winget

winget install "Lenovo Vantage" --source msstore

# install wsl
wsl --install
    ## wsl --list --online
wsl --install Ubuntu

