#!/usr/bin/env bash
#
# setup.sh - Link dotfiles with GNU stow and configure the shell.
#
# Usage:  ./setup.sh [--assume-yes] [--no-shell] [package ...]
#
# With no packages given, every supported package is stowed.
# Pass names to stow only those, e.g.:  ./setup.sh nvim tmux zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

ASSUME_YES=0
NO_SHELL=0
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --assume-yes) ASSUME_YES=1 ;;
    --no-shell)   NO_SHELL=1 ;;
    -h|--help)
      echo "Usage: $0 [--assume-yes] [--no-shell] [package ...]"
      exit 0
      ;;
    *) ARGS+=("$arg") ;;
  esac
done

# ─── Preflight ─────────────────────────────────────────────────────────────
banner "Dotfiles Setup"

require_command stow
require_command git

cd "$DOTFILES_DIR"

# Packages that follow the .config/ layout (stow package == directory name).
ALL_PACKAGES=(git hyprland kitty nvim systemd tmux waybar wofi zsh)

if [[ ${#ARGS[@]} -gt 0 ]]; then
  PACKAGES=("${ARGS[@]}")
else
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

# ─── Set default shell to zsh ──────────────────────────────────────────────
if [[ $NO_SHELL -eq 0 ]] && is_installed zsh; then
  log_step "Setting up: zsh as default shell"
  if [[ "$SHELL" != "/usr/bin/zsh" ]] && [[ "$SHELL" != "/bin/zsh" ]]; then
    if [[ $ASSUME_YES -eq 1 ]] || confirm "Set zsh as your login shell?"; then
      chsh -s /usr/bin/zsh
      log_ok "Default shell set to zsh (restart session to apply)"
    else
      log_skip "Shell unchanged"
    fi
  else
    log_skip "zsh is already the default shell"
  fi
else
  [[ $NO_SHELL -eq 1 ]] && log_skip "Login shell unchanged (--no-shell)." \
    || log_warn "zsh is not installed — skipping shell setup"
fi

# ─── Stow packages ─────────────────────────────────────────────────────────
for pkg in "${PACKAGES[@]}"; do
  if [[ ! -d "$pkg" ]]; then
    log_error "Package directory '$pkg' not found — skipping."
    continue
  fi

  log_step "Linking: $pkg"

  # hyprland ships a managed config file that conflicts with the stowed one.
  if [[ "$pkg" == "hyprland" ]]; then
    rm -f "$HOME/.config/hypr/hyprland.lua"
  fi

  if stow --target "$HOME" -v --restow "$pkg" 2> /dev/null; then
    log_ok "$pkg linked"
  elif stow --target "$HOME" --adopt "$pkg" 2> /dev/null; then
    log_ok "$pkg linked (adopted)"
  else
    log_error "Failed to stow '$pkg'"
  fi
done

# Waybar imports this generated file, which is intentionally ignored because
# the theme toggle rewrites it at runtime. Seed the default for fresh clones.
if [[ " ${PACKAGES[*]} " == *" waybar "* ]] && [[ ! -e "$HOME/.config/waybar/theme.css" ]]; then
  cp "$DOTFILES_DIR/waybar/.config/waybar/themes/dark.css" \
    "$HOME/.config/waybar/theme.css"
  log_ok "Initialized Waybar theme (dark)"
fi

# ─── Runtime profile integration ────────────────────────────────────────────
log_step "Configuring: profile launcher"
mkdir -p "$HOME/.local/bin"
ln -sfn "$DOTFILES_DIR/bin/dotfiles-profile" "$HOME/.local/bin/dotfiles-profile"
"$DOTFILES_DIR/bin/dotfiles-profile" init

if command -v systemctl >/dev/null 2>&1 && systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user daemon-reload
  # The package ships a service, but the profile service must be the only bar
  # supervisor. This also cleans up an older manually enabled Waybar unit.
  systemctl --user disable --now waybar.service >/dev/null 2>&1 || true
  systemctl --user enable dotfiles-shell.service >/dev/null
  log_ok "Profile launcher installed"
else
  log_warn "User systemd is unavailable — profile switching will use its fallback launcher"
fi

# ─── Done ──────────────────────────────────────────────────────────────────
printf "\n"
log_ok "Setup complete."
log_info "Restart your terminal (or re-login) for shell changes to apply."
