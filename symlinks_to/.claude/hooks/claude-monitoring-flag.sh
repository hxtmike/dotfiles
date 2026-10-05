#!/bin/sh
# Pipeline: this hook records *when* (a flag file) -> the status line draws a
# marker -> Herdr reads the screen. No stage talks to the next one directly:
# the hook cannot draw (its stdout never reaches the pane), the status line
# does not know the timing (its JSON has no "waiting" field), and Herdr only
# trusts what it sees on the pane.
#
# Marks this Claude session as "waiting on a monitor / scheduled wake-up" so
# that ~/.claude/statusline-command.sh renders an extra `✳ monitoring…` line.
# Herdr's Claude detection manifest reads that line as a live turn (rule
# live_turn_working, priority 970, above the idle prompt-box rule at 950), so
# the pane keeps the *working* status icon instead of dropping to idle while
# the agent sits at the prompt between polls. Herdr ignores externally
# reported states for agents it has a manifest for, so this is the only lever.
#
# The flag is a file named after the session id under $TMPDIR. The hook
# payload JSON arrives on stdin and supplies that id.
# Usage: claude-monitoring-flag.sh set|clear   (wired up in ~/.claude/settings.json)

set -eu

command -v jq >/dev/null 2>&1 || exit 0
session_id="$(jq -r '.session_id // empty' 2>/dev/null || true)"
[ -n "$session_id" ] || exit 0

flag_dir="${TMPDIR:-/tmp}/claude-monitoring"
case "${1:-}" in
    set) mkdir -p "$flag_dir" && : > "$flag_dir/$session_id" ;;
    clear) rm -f "$flag_dir/$session_id" ;;
esac
exit 0
