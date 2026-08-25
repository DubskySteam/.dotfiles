#!/usr/bin/env bash
#
# media.sh - Now-playing formatter for the waybar custom/media module.
# Emits JSON so CSS can react to play state via .playing/.paused classes.

set -uo pipefail

MAX_ARTIST=20
MAX_TITLE=30

trim() {
  local s=$1 max=$2
  (( ${#s} > max )) && printf '%s…' "${s:0:max-1}" || printf '%s' "$s"
}

status=$(playerctl status 2>/dev/null) || exit 0
case $status in
  Playing) icon="󰏥"; class="playing" ;;   # pause symbol shown while playing
  Paused)  icon="󰐊"; class="paused"  ;;   # play symbol shown while paused
  *) exit 0 ;;
esac

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
[[ -z $artist && -z $title ]] && title=$(playerctl metadata url 2>/dev/null | xargs basename 2>/dev/null)
[[ -z $title ]] && exit 0

esc() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }

text=$(trim "$title" $MAX_TITLE)
[[ -n $artist ]] && text="$(trim "$artist" $MAX_ARTIST) — $text"

tooltip=$(printf '%s\n%s' "$(esc "${artist:-Unknown artist}")" "$(esc "$title")")

printf '{"text": "%s %s", "class": "%s", "tooltip": "%s"}\n' \
  "$icon" "$(esc "$text")" "$class" "$tooltip"
