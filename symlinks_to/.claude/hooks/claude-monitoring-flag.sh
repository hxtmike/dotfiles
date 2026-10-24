#!/bin/sh
# Pipeline: this hook records *when* (a flag file) -> the status line draws a
# marker -> Herdr reads the screen. No stage talks to the next one directly:
# the hook cannot draw (its stdout never reaches the pane), the status line
# does not know the timing (its JSON has no "waiting" field), and Herdr only
# trusts what it sees on the pane.
#
# Marks this Claude session as "waiting on something that will re-invoke it"
# so that ~/.claude/statusline-command.sh renders an extra `✳ monitoring…`
# line. Three tool calls count as waiting:
#   - Monitor and ScheduleWakeup, always;
#   - Bash with run_in_background=true, because the model is re-invoked when
#     the shell exits (Claude Code shows "1 shell still running" meanwhile).
# A foreground Bash call is a normal live turn and sets nothing.
#
# Herdr's Claude detection manifest reads the marker line as a live turn
# (rule live_turn_working, priority 970, above the idle prompt-box rule at
# 950), so the pane keeps the *working* status icon instead of dropping to
# idle while the agent sits at the prompt between polls. Herdr ignores
# externally reported states for agents it has a manifest for, so this is the
# only lever.
#
# The flag is a file named after the session id under $TMPDIR. The hook
# payload JSON arrives on stdin and supplies that id plus the tool call.
# Usage: claude-monitoring-flag.sh set|clear   (wired up in ~/.claude/settings.json)

set -eu

command -v jq >/dev/null 2>&1 || exit 0
# stdin can only be read once and two fields are needed from it (session id,
# then the tool call), so buffer the whole payload first.
payload="$(cat 2>/dev/null || true)"
session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null || true)"
[ -n "$session_id" ] || exit 0

flag_dir="${TMPDIR:-/tmp}/claude-monitoring"
case "${1:-}" in
    set)
        # The settings.json matcher fires on *every* Bash call (it can only
        # match the tool name), but a foreground command is a normal live turn,
        # not a wait. Only tool_input says whether the shell is backgrounded,
        # so the check has to live here: Bash -> true iff run_in_background,
        # anything else (Monitor, ScheduleWakeup) -> always true. A malformed
        # payload yields an empty string, which is treated as "not waiting".
        waiting="$(printf '%s' "$payload" | jq -r \
            'if .tool_name == "Bash" then (.tool_input.run_in_background == true) else true end' \
            2>/dev/null || true)"
        [ "$waiting" = "true" ] || exit 0
        mkdir -p "$flag_dir" && : > "$flag_dir/$session_id"
        ;;
    clear) rm -f "$flag_dir/$session_id" ;;
esac
exit 0
