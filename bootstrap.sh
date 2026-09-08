#!/usr/bin/env bash
#
# bootstrap.sh - Interactive one-and-done setup for a fresh Arch install.
#
# This is intentionally separate from install.sh and setup.sh. It coordinates
# them, asks before privileged/system changes, and leaves the lower-level
# scripts useful for focused maintenance later.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$ROOT_DIR/lib.sh"

ASSUME_YES=0
SKIP_UPDATE=0
INSTALL_SDDM=1
PROFILE=""
NO_SHELL=0
SKIP_UPDATE_SET=0
INSTALL_SDDM_SET=0
NO_SHELL_SET=0

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Options:
  --profile waybar|quickshell  Select the default shell profile.
  --skip-update                Skip the Arch keyring, mirrors, and update.
  --no-sddm                    Do not install the custom SDDM login screen.
  --no-shell                   Keep the current login shell.
  --assume-yes                 Use defaults without interactive confirmations.
  -h, --help                   Show this help.
EOF
}

die() {
  log_error "$1"
  exit 1
}

validate_login_theme() {
  local theme_path=$1
  local output
  local exit_code

  require_command qmllint
  require_command sddm-greeter

  log_step "Validating: SDDM theme QML"
  if ! grep -Eq '^import[[:space:]]+QtQuick\.XmlListModel([[:space:]]|$)' "$theme_path/Main.qml"; then
    die "SDDM theme must import QtQuick.XmlListModel."
  fi
  if grep -Eq '(^|[^[:alnum:]_])XmlListModelRole([^[:alnum:]_]|$)' "$theme_path/Main.qml"; then
    die "SDDM theme uses the Qt 6 XmlListModelRole type; use XmlRole."
  fi
  if ! grep -Eq '(^|[^[:alnum:]_])XmlRole([^[:alnum:]_]|$)' "$theme_path/Main.qml"; then
    die "SDDM theme is missing the Qt 5 XmlRole type."
  fi
  qmllint -I /usr/lib/qt/qml "$theme_path/Main.qml"

  # Test mode is intentionally bounded: a healthy greeter stays running,
  # while parse/type failures exit immediately with a useful error.
  output=$(mktemp)
  if timeout 5s sddm-greeter --test-mode --theme "$theme_path" >"$output" 2>&1; then
    exit_code=0
  else
    exit_code=$?
  fi

  if [[ $exit_code -ne 0 && $exit_code -ne 124 && $exit_code -ne 143 ]]; then
    cat "$output" >&2
    rm -f "$output"
    die "SDDM theme validation failed."
  fi

  if grep -Eiq 'is not a type|qml error|unable to load|failed to load|syntax error' "$output"; then
    cat "$output" >&2
    rm -f "$output"
    die "SDDM theme validation reported a QML error."
  fi

  rm -f "$output"
  log_ok "SDDM theme passed QML and greeter validation"
}

while [[ $# -gt 0 ]]; do
  arg=$1
  shift
  case "$arg" in
    --profile=waybar|--profile=quickshell) PROFILE="${arg#*=}" ;;
    --profile)
      [[ $# -gt 0 ]] || die "--profile requires waybar or quickshell"
      PROFILE=$1
      shift
      [[ "$PROFILE" == waybar || "$PROFILE" == quickshell ]] || die "--profile requires waybar or quickshell"
      ;;
    --skip-update) SKIP_UPDATE=1; SKIP_UPDATE_SET=1 ;;
    --no-sddm) INSTALL_SDDM=0; INSTALL_SDDM_SET=1 ;;
    --no-shell) NO_SHELL=1; NO_SHELL_SET=1 ;;
    --assume-yes) ASSUME_YES=1 ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown option: $arg" ;;
  esac
done

if [[ $EUID -eq 0 ]]; then
  die "Run this as your normal user, not as root. The script will use sudo when needed."
fi

require_command pacman
require_command sudo
[[ -f /etc/arch-release ]] || log_warn "This does not look like an Arch Linux installation."

choose_profile() {
  [[ -n "$PROFILE" ]] && return 0
  if [[ $ASSUME_YES -eq 1 ]]; then
    PROFILE=waybar
    return 0
  fi

  printf '\n'
  printf '  %b1%b) Waybar      %bEstablished, lightweight baseline%b\n' "$C_BOLD$C_GREEN" "$C_CLEAR" "$C_DIM" "$C_CLEAR"
  printf '  %b2%b) Quickshell  %bNew event-driven custom shell%b\n' "$C_BOLD$C_MAGENTA" "$C_CLEAR" "$C_DIM" "$C_CLEAR"
  while :; do
    read -r -p "  Choose the default profile [1]: " choice
    case "${choice:-1}" in
      1) PROFILE=waybar; return 0 ;;
      2) PROFILE=quickshell; return 0 ;;
      *) log_warn "Please choose 1 or 2." ;;
    esac
  done
}

confirm_or_exit() {
  [[ $ASSUME_YES -eq 1 ]] && return 0
  confirm "$1" || die "Setup cancelled."
}

ask_default_yes() {
  local reply
  [[ $ASSUME_YES -eq 1 ]] && return 0
  read -r -p "  $1 [Y/n] " reply
  [[ "${reply,,}" != n && "${reply,,}" != no ]]
}

choose_options() {
  [[ $ASSUME_YES -eq 1 ]] && return 0

  if [[ $SKIP_UPDATE_SET -eq 0 ]] && ! ask_default_yes "Run the full Arch update and mirror refresh?"; then
    SKIP_UPDATE=1
  fi
  if [[ $INSTALL_SDDM_SET -eq 0 ]] && ! ask_default_yes "Install the custom SDDM login screen?"; then
    INSTALL_SDDM=0
  fi
  if [[ $NO_SHELL_SET -eq 0 ]] && ! ask_default_yes "Set zsh as the default login shell?"; then
    NO_SHELL=1
  fi
}

install_login_theme() {
  local theme_dir="/usr/share/sddm/themes/dubsky"
  local session_dir="/usr/local/share/wayland-sessions"
  local state_dir="/var/lib/dotfiles"
  local group

  group=$(id -gn)
  log_step "Installing: custom SDDM login screen"
  sudo install -d -m 755 "$theme_dir" "$session_dir" "$state_dir" /etc/sddm.conf.d
  sudo chown "$(id -un):$group" "$state_dir"

  sudo install -Dm644 "$ROOT_DIR/sddm/dubsky/Main.qml" \
    "$theme_dir/Main.qml"
  sudo install -Dm644 "$ROOT_DIR/sddm/dubsky/theme.conf" \
    "$theme_dir/theme.conf"
  sudo install -Dm644 "$ROOT_DIR/res/wallpaper.png" \
    "$theme_dir/wallpaper.png"
  sudo install -Dm644 "$ROOT_DIR/sddm/dotfiles.conf" \
    /etc/sddm.conf.d/10-dotfiles.conf
  sudo install -Dm755 "$ROOT_DIR/sddm/dotfiles-hyprland" \
    /usr/local/bin/dotfiles-hyprland
  sudo install -Dm644 "$ROOT_DIR/sddm/wayland-sessions/hyprland-waybar.desktop" \
    "$session_dir/hyprland-waybar.desktop"
  sudo install -Dm644 "$ROOT_DIR/sddm/wayland-sessions/hyprland-quickshell.desktop" \
    "$session_dir/hyprland-quickshell.desktop"

  validate_login_theme "$theme_dir"
  log_ok "SDDM theme and profile sessions installed"
}

switch_display_manager() {
  local current=""
  local target="sddm.service"

  current=$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || true)
  current=${current##*/}

  if [[ -n "$current" && "$current" != "$target" ]] && systemctl is-active --quiet display-manager.service; then
    if [[ $ASSUME_YES -eq 1 ]] || confirm "Replace the active display manager ($current) with SDDM?"; then
      sudo systemctl disable --now "$current"
    else
      log_warn "SDDM was installed but the active display manager was left unchanged."
      return 0
    fi
  fi

  sudo systemctl enable sddm.service
  log_ok "SDDM enabled for the next boot"
}

main() {
  banner "Dubsky Dotfiles Bootstrap"
  choose_profile
  choose_options
  printf '%b  Profile: %s%b\n' "$C_BOLD$C_MAGENTA" "$PROFILE" "$C_CLEAR"
  printf '%b  This will install Arch packages, link configs, and configure the selected desktop shell.%b\n\n' "$C_DIM" "$C_CLEAR"
  confirm_or_exit "Continue with the dotfiles setup?"

  log_step "Checking sudo access"
  sudo -v
  log_ok "sudo access confirmed"

   install_args=(--assume-yes)
  [[ $SKIP_UPDATE -eq 1 ]] && install_args+=(--skip-update)
  log_step "Installing: Arch packages"
  "$ROOT_DIR/install.sh" "${install_args[@]}"

  setup_args=(--assume-yes)
  [[ $NO_SHELL -eq 1 ]] && setup_args+=(--no-shell)
  log_step "Linking: dotfiles"
  "$ROOT_DIR/setup.sh" "${setup_args[@]}"

  sudo systemctl enable --now NetworkManager.service >/dev/null
  log_ok "NetworkManager enabled"

  # The state directory is deliberately readable by SDDM but writable by the
  # account that owns the dotfiles. The profile manager falls back to XDG
  # state if this optional system directory cannot be created.
  sudo install -d -m 755 -o "$(id -un)" -g "$(id -gn)" /var/lib/dotfiles
  "$ROOT_DIR/bin/dotfiles-profile" set "$PROFILE" --no-restart >/dev/null

  if [[ $INSTALL_SDDM -eq 1 ]]; then
    install_login_theme
    switch_display_manager
  else
    log_skip "Custom SDDM login screen skipped (--no-sddm)."
  fi

  printf '\n'
  printf '%b%s%b\n' "$C_BOLD$C_GREEN" "Bootstrap complete." "$C_CLEAR"
  printf '  Active profile: %s\n' "$PROFILE"
  printf '  Switch later:   %b$HOME/.local/bin/dotfiles-profile menu%b\n' "$C_CYAN" "$C_CLEAR"
  printf '  Apply fully:    log out and choose the matching SDDM profile.\n'
}

main "$@"
