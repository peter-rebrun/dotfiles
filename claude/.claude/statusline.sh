#!/usr/bin/env bash
# Claude Code status line: session id + 5h / 7d plan usage.
# Rate-limit fields only exist on Pro/Max/Ultra plans, after the first API response.
input=$(cat)

session=$(echo "$input" | jq -r '.session_id // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

dim=$'\033[2m'; reset=$'\033[0m'
green=$'\033[32m'; yellow=$'\033[33m'; red=$'\033[31m'

colour() {
  local pct=${1%.*}
  if [ "$pct" -ge 90 ]; then printf '%s' "$red"
  elif [ "$pct" -ge 70 ]; then printf '%s' "$yellow"
  else printf '%s' "$green"; fi
}

# Epoch seconds -> local time. 5h shows HH:MM, 7d shows weekday HH:MM.
fmt_reset() {
  [ -n "$1" ] || return
  date -r "${1%.*}" +"$2" 2>/dev/null
}

out="${dim}Session: ${session}${reset}"

if [ -n "$five" ]; then
  out+="  $(colour "$five")5h ${five%.*}%${reset}"
  r=$(fmt_reset "$five_reset" '%H:%M'); [ -n "$r" ] && out+="${dim} ↻${r}${reset}"
fi

if [ -n "$week" ]; then
  out+="  $(colour "$week")7d ${week%.*}%${reset}"
  r=$(fmt_reset "$week_reset" '%a %H:%M'); [ -n "$r" ] && out+="${dim} ↻${r}${reset}"
fi

printf '%s' "$out"
