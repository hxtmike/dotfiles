# Jobs to run at shell startup, at most once every so many hours.
# Register one from any file sourced before .zshrc calls zsh_periodic_run:
#
#     zsh_periodic+=("<hours> <command>")
typeset -ga zsh_periodic

# Run a command in the first shell opened once <hours> have passed since its last run.
# Usage: run_every <hours> <command> [<argument>...]
# A job is identified by its command name: one stamp per command name, whatever
# the arguments. The stamp's modification time is the last run.
run_every() {
    if [[ $1 != <1-> || -z $2 ]]; then
        print -ru2 -- "zsh_periodic: invalid entry '$*', expected '<hours> <command>'"
        return 1
    fi
    local stamp=${XDG_STATE_HOME:-$HOME/.local/state}/run_every/$2
    # mh-N: modified less than N hours ago
    local -a recent=($stamp(N.mh-$1))
    (( $#recent )) && return
    # Stamp before running so interruptions don't trigger a retry within the interval
    mkdir -p ${stamp:h} && touch $stamp && print -r -- "⏰ ${@:2}" || return
    # Blank line after the job's output, whatever its outcome; keeps the job's status
    { "${@:2}" } always { print }
}

# Run every due job in zsh_periodic, in the foreground.
zsh_periodic_run() {
    local job
    for job in "$zsh_periodic[@]"; do run_every ${=job}; done
}
