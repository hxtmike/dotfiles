# ~/.zshenv is read by EVERY zsh: interactive or not, login or not.
# Keep it tiny and silent; it runs for every script and every `zsh -c`.

# direnv for non-interactive shells. The oh-my-zsh direnv plugin only hooks the
# interactive prompt, so scripts, `zsh -c` and coding agents' shell tools never
# evaluate .envrc. Evaluating `direnv export` here closes that gap: every new
# shell gets the current state of the .env files above $PWD, so a token rotated
# in .env reaches a long-running agent session on its next command without a
# restart. Interactive shells are left to the prompt hook. DIRENV_LOG_FORMAT=
# drops the "direnv: loading" line (otherwise printed on every command once the
# inherited state goes stale); errors such as a blocked .envrc still print.
if [[ ! -o interactive ]] && (( $+commands[direnv] )); then
    eval "$(DIRENV_LOG_FORMAT= direnv export zsh)"
fi

# Machine-local additions (private dotfiles repo), same pattern as .zshrc.local
[[ -r "$HOME/.config/zsh/.zshenv.local" ]] && source "$HOME/.config/zsh/.zshenv.local"
