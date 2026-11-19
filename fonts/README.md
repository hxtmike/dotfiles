# Font: Fira Mono Nerd Font

One font everywhere. The family name to use in a config is `FiraMono Nerd Font Mono`.

## Install

- macOS: `cask "font-fira-mono-nerd-font"` in `setup_scripts/macos/Brewfile`
- Elsewhere: download "FiraMono" from <https://www.nerdfonts.com/font-downloads>

## Where it is set

| App | File | Setting |
| -- | -- | -- |
| Ghostty | `symlinks_to/.config/ghostty/config` | `font-family` |
| VS Code | `symlinks_to/vscode/settings.json` | `editor.fontFamily`, `terminal.integrated.fontFamily` |
| Herdr | none | Runs inside a terminal, so it shows that terminal's font |

To change the font, update the Brewfile and the two files above.
