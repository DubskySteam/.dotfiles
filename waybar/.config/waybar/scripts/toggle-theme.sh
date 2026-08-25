#!/usr/bin/env bash
#
# toggle-theme.sh - Switch waybar between dark and light themes.
#
#   toggle-theme.sh          flip theme (also syncs GTK color scheme + Hyprland borders)
#   toggle-theme.sh status   emit JSON for the waybar custom/theme button
#
# Hot-reloads the bar with SIGUSR2 and pokes the button via RTMIN+8.

set -uo pipefail

DIR="$HOME/.config/waybar"
STATE_FILE="$HOME/.cache/waybar-theme"

current=$(cat "$STATE_FILE" 2>/dev/null || echo dark)
[[ $current != dark && $current != light ]] && current=dark

if [[ ${1:-} == "status" ]]; then
  if [[ $current == dark ]]; then
    printf '{"text": "", "class": "dark"}\n'
  else
    printf '{"text": "", "class": "light"}\n'
  fi
  exit 0
fi

if [[ $current == dark ]]; then next=light; else next=dark; fi

echo "$next" > "$STATE_FILE"
cp "$DIR/themes/$next.css" "$DIR/theme.css"

# Reload waybar CSS + refresh the toggle button
pkill -USR2 -x waybar 2>/dev/null
for pid in $(pgrep -x waybar); do kill -s RTMIN+8 "$pid" 2>/dev/null; done

# Best effort: follow with GTK apps
if command -v gsettings >/dev/null 2>&1; then
  scheme=$([[ $next == dark ]] && echo prefer-dark || echo prefer-light)
  gsettings set org.gnome.desktop.interface color-scheme "$scheme" 2>/dev/null
fi

# Best effort: match Hyprland border colors
if command -v hyprctl >/dev/null 2>&1 && [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
  if [[ $next == dark ]]; then
    hyprctl keyword general:col.active_border "rgba(33ccffee) rgba(00ff99ee) 45" >/dev/null 2>&1
  else
    hyprctl keyword general:col.active_border "rgba(2e7de9ee) rgba(9854f1ee) 45" >/dev/null 2>&1
  fi
fi
