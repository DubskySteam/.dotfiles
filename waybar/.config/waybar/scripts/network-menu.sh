#!/usr/bin/env bash
#
# network-menu.sh - Interactive network dropdown for waybar.
# Opens a wofi dmenu with connection info and Wi-Fi management.

set -uo pipefail

SEP="─────────────────────────────────────"
WIFI_ON_ICON="󰖩"
WIFI_OFF_ICON="󰤮"

# ─── Helpers ────────────────────────────────────────────────────────────────

signal_bars() {
  local s=$1
  if   (( s >= 80 )); then printf '▂▄▆█'
  elif (( s >= 60 )); then printf '▂▄▆'
  elif (( s >= 40 )); then printf '▂▄'
  elif (( s >= 15 )); then printf '▂'
  else                     printf '·'
  fi
}

wifi_enabled() {
  [[ $(nmcli radio wifi) == "enabled" ]]
}

current_essid() {
  nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null \
    | awk -F: '$2 == "802-11-wireless" { sub(/\\:/,":",$1); print $1; exit }'
}

current_ip() {
  nmcli -t -f IP4.GATEWAY device show 2>/dev/null | head -1 >/dev/null
  ip -4 addr show scope global 2>/dev/null | awk '/inet /{ split($2,a,"/"); print a[1]; exit }'
}

theme() {
  cat "$HOME/.cache/waybar-theme" 2>/dev/null || echo dark
}

pick() {
  wofi --dmenu --prompt "$1" --width 480 --height "${2:-500}" \
       --hide-scroll --insensitive \
       --style "$HOME/.config/wofi/themes/$(theme).css"
}

# ─── Menu content ───────────────────────────────────────────────────────────

build_menu() {
  local essid ipaddr line

  if wifi_enabled; then
    essid=$(current_essid)
    ipaddr=$(current_ip)

    if [[ -n $essid ]]; then
      local sig
      sig=$(nmcli -t -f IN-USE,SIGNAL device wifi list --rescan no 2>/dev/null \
              | awk -F: '$1=="*"{print $2; exit}')
      [[ -z $sig ]] && sig=100
      printf '%s  %s  %s %s%%\n' "$WIFI_ON_ICON" "$essid" "$(signal_bars "$sig")" "$sig"
      printf '  %s\n' "${ipaddr:-no address}"
      printf '%s\n' "$SEP"
      printf ' Disconnect from "%s"\n' "$essid"
    else
      printf '%s  Wi-Fi on — not connected\n' "$WIFI_ON_ICON"
      printf '  %s\n' "${ipaddr:-no address}"
      printf '%s\n' "$SEP"
    fi

    printf ' Connect to Wi-Fi…\n'
    printf ' Toggle Wi-Fi  [ON]\n'
  else
    printf '%s  Wi-Fi off\n' "$WIFI_OFF_ICON"
    printf '%s\n' "$SEP"
    printf ' Toggle Wi-Fi  [OFF]\n'
  fi

  printf ' Network settings…\n'
}

list_networks() {
  # Nearby APs: SSID:SIGNAL:SECURITY (strongest first)
  nmcli -t -f SSID,SIGNAL,SECURITY device wifi list --rescan auto 2>/dev/null \
    | awk -F: '
        $1 != "" && $1 != "--" {
          sig = $2 + 0
          if (!seen[$1]++ || sig > best[$1]) { best[$1] = sig; row[$1] = $0 }
        }
        END { for (s in row) print row[s] }
      ' \
    | sort -t: -k2,2rn \
    | while IFS=: read -r ssid sig sec; do
        local bars mark=""
        bars=$(signal_bars "$sig")
        [[ $ssid == "$(current_essid)" ]] && mark="● "
        sec=${sec:-open}
        printf '%s%-24s  %s %s%%   (%s)\n' "$mark" "$ssid" "$bars" "$sig" "$sec"
      done
}

connect_flow() {
  local ssid=$1 sec=$2 known=$3 pass=""

  if [[ $known == no ]]; then
    pass=$(wofi --dmenu --password --prompt "password: $ssid" --width 380 --height 90 \
             --style "$HOME/.config/wofi/themes/$(theme).css") || return 0
    [[ -z $pass ]] && return 0
    nmcli device wifi connect "$ssid" password "$pass" >/dev/null 2>&1 &
  else
    nmcli connection up "$ssid" >/dev/null 2>&1 &
  fi
}

# ─── Main ───────────────────────────────────────────────────────────────────

main_menu() {
  local sel
  sel=$( { build_menu; echo "$SEP"; list_networks; } | pick "network") || exit 0
  [[ -z $sel ]] && exit 0

  case $sel in
    *"Connect to Wi-Fi"*|*"Toggle Wi-Fi"*)
      if [[ $sel == *"[OFF]"* ]]; then
        nmcli radio wifi on
      elif [[ $sel == *"[ON]"* ]]; then
        nmcli radio wifi off
        exit 0
      fi
      exec "$0" ;;
    *"Rescan"*)          nmcli device wifi rescan 2>/dev/null; sleep 1.5; exec "$0" ;;
    *"Network settings"*)
      if command -v nm-connection-editor >/dev/null 2>&1; then
        nm-connection-editor & disown
      else
        kitty nmtui & disown
      fi
      exit 0 ;;
    *"Disconnect"*)
      nmcli device disconnect wlan0 >/dev/null 2>&1 || \
        nmcli device disconnect "$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2=="wifi"{print $1; exit}')" >/dev/null 2>&1
      exit 0 ;;
    *)
      # A nearby AP row: "● ssid  bars sig%  (security)"
      local ssid sec
      ssid=$(printf '%s' "$sel" | sed -e 's/^● *//' -e 's/ *[▂▄▆█·].*$//')
      sec=$(printf '%s' "$sel" | grep -oP '(?<=\()[a-z\- ]+(?=\))')
      [[ -z $ssid ]] && exit 0

      if nmcli -t -f NAME connection show 2>/dev/null | sed 's/\\:/:/g' | grep -qxF "$ssid"; then
        connect_flow "$ssid" "$sec" yes
      else
        connect_flow "$ssid" "$sec" no
      fi
      exit 0 ;;
  esac
}

main_menu
