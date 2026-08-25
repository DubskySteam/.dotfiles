#!/usr/bin/env bash
#
# audio-menu.sh - Interactive audio dropdown for waybar.
# Shows current output/input state, lets you pick devices, mute, open mixer.

set -uo pipefail

SEP="─────────────────────────────────────"

# ─── wpctl parsing ──────────────────────────────────────────────────────────

# Emits lines like: "sinks|47|●|Family Room Speaker"
list_nodes() {
  local want=$1
  wpctl status 2>/dev/null | awk -v want="$want" '
    /^[A-Z]/            { sec = "" }
    /Sinks:/  && !/Source/ { sec = "sinks" }
    /Sources:/           { if (sec == "" || sec == "sinks") sec = "sources" }
    sec == want && /[0-9]+\. / {
      orig = $0
      line = $0
      sub(/^[^0-9]*/, "", line)
      id = line;  sub(/\..*/, "", id)
      desc = line; sub(/^[0-9]+\. /, "", desc); sub(/ \[vol:.*/, "", desc)
      gsub(/[ \t]+$/, "", desc)
      mark = (orig ~ /\* /) ? "●" : "○"
      printf "%s|%s|%s|%s\n", want, id, mark, desc
    }
  '
}

default_vol() {
  wpctl get-volume "@DEFAULT_$1@" 2>/dev/null
}

vol_percent() {
  awk '{ printf "%d", $2 * 100 }' <<< "$(default_vol "$1" | sed 's/MUTED//')"
}

is_muted() {
  [[ $(default_vol "$1") == *"MUTED"* ]]
}

theme() {
  cat "$HOME/.cache/waybar-theme" 2>/dev/null || echo dark
}

pick() {
  wofi --dmenu --prompt "$1" --width 480 --height "${2:-520}" \
       --hide-scroll --insensitive \
       --style "$HOME/.config/wofi/themes/$(theme).css"
}

# ─── Menu ───────────────────────────────────────────────────────────────────

build_menu() {
  local sink_desc sink_vol mic_state

  sink_desc=$(wpctl status 2>/dev/null \
    | awk '/Sinks:/ {f=1} f && /\* / {sub(/^[^0-9]*/,""); sub(/\..*\. /," "); sub(/ \[vol:.*/,""); print; exit}')

  sink_vol=$(is_muted SINK && echo muted || echo "$(vol_percent SINK)%")
  mic_state=$(is_muted SOURCE && echo "muted 󰝟" || echo "live 󰍬")

  printf '%-10s %s   [%s]\n' "Output:" "${sink_desc:-unknown}" "$sink_vol"
  printf '%-10s %s\n' "Mic:" "$mic_state"
  printf '%s\n' "$SEP"

  echo " Output devices:"
  list_nodes sinks   | awk -F'|' '{ printf "   %s %s\n", $3, $4 }'
  echo " Input devices:"
  list_nodes sources | awk -F'|' '{ printf "   %s %s\n", $3, $4 }'
  printf '%s\n' "$SEP"

  is_muted SINK   && printf ' Unmute output\n' || printf ' Mute output\n'
  is_muted SOURCE && printf ' Unmute mic\n'    || printf ' Mute mic\n'
  printf ' Open mixer (pavucontrol)…\n'
}

handle_selection() {
  local sel=$1

  case $sel in
    *"Mute output"*|*"Unmute output"*) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    *"Mute mic"*|*"Unmute mic"*)       wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    *"Open mixer"*)
      command -v pavucontrol >/dev/null 2>&1 && pavucontrol & disown
      exit 0 ;;
    ●*)
      # Device rows: "   ● Description" — resolve id from description
      local desc id kind
      desc=${sel#*● }
      for kind in sinks sources; do
        while IFS='|' read -r _ node_id _ node_desc; do
          if [[ $node_desc == "$desc" ]]; then
            wpctl set-default "$node_id"
            exit 0
          fi
        done < <(list_nodes "$kind")
      done
      ;;
  esac
}

# ─── Main ───────────────────────────────────────────────────────────────────

sel=$(build_menu | pick "audio") || exit 0
[[ -z $sel ]] && exit 0
handle_selection "$sel"
