#!/usr/bin/env bash
#
# settings-menu.sh - Settings dropdown for waybar.
# Desktop toggles + reload actions. Re-opens itself after state changes.

set -uo pipefail

SEP="──────────────────────────────"
STATE_FILE="$HOME/.cache/waybar-theme"

theme=$(cat "$STATE_FILE" 2>/dev/null || echo dark)

# ─── Helpers ────────────────────────────────────────────────────────────────

opt_bool() {
  hyprctl -j getoption "$1" 2>/dev/null | grep -o '"bool": *[a-z]*' | grep -oE '[a-z]+$'
}

opt_on() {
  [[ $(opt_bool "$1") == true ]]
}

gaps_on() {
  local v
  v=$(hyprctl -j getoption general:gaps_in 2>/dev/null | grep -oE '"(css|str)": *"[^"]*"' | grep -oE '[0-9]+' | head -1)
  [[ ${v:-0} -gt 0 ]]
}

pick() {
  wofi --dmenu --prompt "$1" --width 420 --height "${2:-420}" \
       --hide-scroll --insensitive \
       --style "$HOME/.config/wofi/themes/$theme.css"
}

# ─── Menu ───────────────────────────────────────────────────────────────────

build_menu() {
  printf ' Theme        [%s]\n' "$theme"
  printf ' Blur         [%s]\n' "$(opt_on decoration:blur:enabled && echo on || echo off)"
  printf ' Animations   [%s]\n' "$(opt_on animations:enabled && echo on || echo off)"
  printf ' Gaps         [%s]\n' "$(gaps_on && echo on || echo off)"
  printf ' Shell        [%s]\n' "$("$HOME/.local/bin/dotfiles-profile" current 2>/dev/null || echo waybar)"
  printf '%s\n' "$SEP"
  printf ' Reload Hyprland\n'
  printf ' Restart Waybar\n'
  printf ' Edit dotfiles…\n'
}

# ─── Main ───────────────────────────────────────────────────────────────────

sel=$(build_menu | pick "settings") || exit 0
[[ -z $sel ]] && exit 0

case $sel in
  *"Theme"*)
    "$HOME/.config/waybar/scripts/toggle-theme.sh"
    exit 0 ;;
  *"Blur"*)
    opt_on decoration:blur:enabled \
      && hyprctl keyword decoration:blur:enabled false >/dev/null \
      || hyprctl keyword decoration:blur:enabled true >/dev/null
    exec "$0" ;;
  *"Animations"*)
    opt_on animations:enabled \
      && hyprctl keyword animations:enabled false >/dev/null \
      || hyprctl keyword animations:enabled true >/dev/null
    exec "$0" ;;
  *"Gaps"*)
    if gaps_on; then
      hyprctl keyword general:gaps_in 0  >/dev/null
      hyprctl keyword general:gaps_out 0 >/dev/null
    else
      hyprctl keyword general:gaps_in 5  >/dev/null
      hyprctl keyword general:gaps_out 20 >/dev/null
    fi
    exec "$0" ;;
  *"Shell"*) "$HOME/.local/bin/dotfiles-profile" menu; exit 0 ;;
  *"Reload Hyprland"*) hyprctl reload >/dev/null 2>&1; exit 0 ;;
  *"Restart Waybar"*)  killall waybar 2>/dev/null; sleep 0.3; nohup waybar >/dev/null 2>&1 & exit 0 ;;
  *"Edit dotfiles"*)   kitty --directory "$HOME/.dotfiles" & disown; exit 0 ;;
esac
