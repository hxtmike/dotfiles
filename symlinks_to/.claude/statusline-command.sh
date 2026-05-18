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
display_dir="${cwd/#$home/\~}"

parts=()
parts+=("$display_dir")
[ -n "$model" ] && parts+=("$model")
[ -n "$used_pct" ] && parts+=("ctx: $(printf '%.0f' "$used_pct")%")

rate_parts=()
[ -n "$five_hour" ] && rate_parts+=("5h: $(printf '%.0f' "$five_hour")%")
[ -n "$seven_day" ] && rate_parts+=("7d: $(printf '%.0f' "$seven_day")%")
[ ${#rate_parts[@]} -gt 0 ] && parts+=("${(j:  :)rate_parts}")

printf '%s\n' "${(j: | :)parts}"
