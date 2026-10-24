#!/usr/bin/env zsh
# Claude Code status line script

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Shorten cwd: replace $HOME with ~
home="$HOME"
display_dir="${cwd/#$home/~}"

parts=()
parts+=("$display_dir")
[ -n "$model" ] && parts+=("$model")
[ -n "$used_pct" ] && parts+=("ctx: $(printf '%.0f' "$used_pct")%")

rate_parts=()
[ -n "$five_hour" ] && rate_parts+=("5h: $(printf '%.0f' "$five_hour")%")
[ -n "$seven_day" ] && rate_parts+=("7d: $(printf '%.0f' "$seven_day")%")
[ ${#rate_parts[@]} -gt 0 ] && parts+=("${(j:  :)rate_parts}")

printf '%s\n' "${(j: | :)parts}"

# Middle stage of a three-step pipeline: hooks/claude-monitoring-flag.sh
# records *when* (a flag file) -> this block draws a marker -> Herdr reads the
# screen. None of the three talks to the next one directly; the flag file and
# the rendered line are the only handovers.
#
# A fresh flag means the session is waiting on a monitor, a scheduled
# wake-up or a background shell. The line must start with ✳ and end with …:
# Herdr's Claude manifest matches that shape as a live turn
# (live_turn_working), which keeps the pane's status icon on "working" rather
# than idle. Flags older than an hour are ignored in case the clearing hook
# never fired.
session_id=$(echo "$input" | jq -r '.session_id // ""')
flag="${TMPDIR:-/tmp}/claude-monitoring/$session_id"
if [ -n "$session_id" ] && [ -n "$(find "$flag" -mmin -60 2>/dev/null)" ]; then
    printf '%s\n' '✳ monitoring…'
fi
