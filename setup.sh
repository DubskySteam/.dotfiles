#!/usr/bin/env bash
#
# setup.sh - Link dotfiles with GNU stow and configure the shell.
#
# Usage:  ./scripts/setup.sh [--assume-yes] [package ...]
#
# With no packages given, every supported package is stowed.
# Pass names to stow only those, e.g.:  ./scripts/setup.sh nvim tmux zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

ASSUME_YES=0
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --assume-yes) ASSUME_YES=1 ;;
    -h|--help)
      echo "Usage: $0 [--assume-yes] [package ...]"
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
ALL_PACKAGES=(git hyprland kitty nvim tmux waybar wofi zsh)

if [[ ${#ARGS[@]} -gt 0 ]]; then
  PACKAGES=("${ARGS[@]}")
else
  PACKAGES=("${ALL_PACKAGES[@]}")
fi

# ─── Set default shell to zsh ──────────────────────────────────────────────
if is_installed zsh; then
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
  log_warn "zsh is not installed — skipping shell setup"
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

  if stow -v --restow "$pkg" 2> /dev/null; then
    log_ok "$pkg linked"
  elif stow --adopt "$pkg" 2> /dev/null; then
    log_ok "$pkg linked (adopted)"
  else
    log_error "Failed to stow '$pkg'"
  fi
done

# ─── Done ──────────────────────────────────────────────────────────────────
printf "\n"
log_ok "Setup complete."
log_info "Restart your terminal (or re-login) for shell changes to apply."
