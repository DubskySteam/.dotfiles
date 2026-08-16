#!/usr/bin/env bash
#
# install.sh - Full Arch Linux setup: keyring, mirrors, system update,
#              essential packages, AUR helper (paru), and app stack.
#
# Usage:  ./scripts/install.sh [--skip-update] [--assume-yes]
#
# Options:
#   --skip-update  Skip the keyring/mirror/system update phase.
#   --assume-yes   Answer 'yes' to all interactive prompts (for automation).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

ASSUME_YES=0
SKIP_UPDATE=0
for arg in "$@"; do
  case "$arg" in
    --skip-update) SKIP_UPDATE=1 ;;
    --assume-yes)  ASSUME_YES=1 ;;
    -h|--help)
      echo "Usage: $0 [--skip-update] [--assume-yes]"
      exit 0
      ;;
    *) log_error "Unknown argument: $arg"; exit 1 ;;
  esac
done

# ─── Preflight ─────────────────────────────────────────────────────────────
banner "Arch Linux Auto-Install"

require_command pacman || true
if ! is_installed reflector; then
  log_warn "reflector not found — it will be installed during the update phase."
fi

[[ $ASSUME_YES -eq 0 ]] && ! confirm "Run full install now?" && {
  log_warn "Installation aborted."
  exit 1
}

# ─── 1. System update ──────────────────────────────────────────────────────
if [[ $SKIP_UPDATE -eq 0 ]]; then
  log_step "Updating: Keyring"
  sudo pacman -Sy --noconfirm archlinux-keyring reflector

  log_step "Updating: Mirrors"
  sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

  log_step "Updating: System"
  sudo pacman -Syu --noconfirm
else
  log_skip "System update skipped (--skip-update)."
fi

# ─── 2. Essentials ─────────────────────────────────────────────────────────
log_step "Installing: Essentials"
pacman_install \
  stow git tmux wget gpgme eza base-devel cmake make wofi ninja gradle \
  github-cli zsh zsh-autosuggestions zsh-syntax-highlighting \
  zsh-history-substring-search zoxide direnv

# ─── 3. AUR helper (paru) ──────────────────────────────────────────────────
if ! is_installed paru; then
  log_step "Installing: paru (AUR helper)"
  _paru_build="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$_paru_build"
  (cd "$_paru_build" && makepkg -si --noconfirm)
  rm -rf "$_paru_build"
  log_ok "paru installed"
else
  log_skip "paru already installed"
fi

# ─── 4. QoL tools ──────────────────────────────────────────────────────────
log_step "Installing: QoL Tools"
pacman_install mpv
paru_install brave-bin hyprpolkitagent hyprshutdown hyprpaper waybar yazi

# ─── 5. Fonts ──────────────────────────────────────────────────────────────
log_step "Installing: Fonts"
paru_install ttf-jetbrains-mono-nerd otf-font-awesome

# ─── 6. Languages & environments ───────────────────────────────────────────
log_step "Installing: Languages & Environments"
pacman_install neovim python gcc

# ─── Done ──────────────────────────────────────────────────────────────────
printf "\n"
log_ok "Installation complete."
log_info "Next step: run ${C_BOLD}./scripts/setup.sh${C_CLEAR} to link dotfiles."
