#!/usr/bin/env bash
#
# lib.sh - Shared helpers for the dotfiles scripts.
# Sourced by bootstrap.sh, install.sh, and setup.sh. Not meant to be run directly.

# ─── Colors ────────────────────────────────────────────────────────────────
C_CLEAR='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_UNDERLINE='\033[4m'

C_BLACK='\033[0;30m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_MAGENTA='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;37m'

C_BG_BLUE='\033[44m'
C_BG_GREEN='\033[42m'
C_BG_RED='\033[41m'

# ─── Logging ───────────────────────────────────────────────────────────────
log_info()  { printf "  ${C_BLUE}ℹ${C_CLEAR} %s\n"      "$*"; }
log_ok()    { printf "  ${C_GREEN}✔${C_CLEAR} %s\n"      "$*"; }
log_warn()  { printf "  ${C_YELLOW}⚠${C_CLEAR} %s\n"     "$*"; }
log_error() { printf "  ${C_RED}✖${C_CLEAR} %s\n"        "$*" >&2; }
log_step()  { printf "\n${C_BOLD}${C_CYAN}==>${C_CLEAR} ${C_BOLD}%s${C_CLEAR}\n" "$*"; }
log_skip()  { printf "  ${C_DIM}${C_CYAN}−${C_CLEAR} %s\n" "$*"; }
log_debug() { [[ -n "${DEBUG:-}" ]] && printf "  ${C_MAGENTA}◆${C_CLEAR} %s\n" "$*" || true; }

# ─── Banner ────────────────────────────────────────────────────────────────
banner() {
  local title="$1"
  local width=56
  printf "${C_CYAN}"
  printf "┌────────────────────────────────────────────────────────┐\n"
  printf "│ %-54s │\n" "$title"
  printf "│                                                        │\n"
  printf "│  https://github.com/DubskySteam/.dotfiles              │\n"
  printf "└────────────────────────────────────────────────────────┘\n"
  printf "${C_CLEAR}\n"
}

# ─── Checks ────────────────────────────────────────────────────────────────
require_root() {
  [[ "$(id -u)" -eq 0 ]] && return 0
  log_error "This step must be run as root (use sudo)."
  exit 1
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_error "Required command '${cmd}' not found."
    exit 1
  fi
}

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

is_pacman_installed() {
  pacman -Qi "$1" >/dev/null 2>&1
}

is_aur_installed() {
  paru -Qq "$1" >/dev/null 2>&1
}

# ─── Prompts ───────────────────────────────────────────────────────────────
confirm() {
  local msg="$1"
  local reply
  printf "  ${C_YELLOW}?${C_CLEAR} %s ${C_BOLD}${C_GREEN}[y/N]${C_CLEAR} " "$msg"
  read -r reply
  case "${reply,,}" in
    y|yes) return 0 ;;
    *) return 1 ;;
  esac
}

# ─── Package helpers ───────────────────────────────────────────────────────
# Install a list of packages via pacman (skips already-installed ones).
pacman_install() {
  local missing=()
  local pkg
  for pkg in "$@"; do
    if is_pacman_installed "$pkg"; then
      log_skip "$pkg already installed"
    else
      missing+=("$pkg")
    fi
  done
  [[ ${#missing[@]} -eq 0 ]] && return 0

  log_info "Installing via pacman: ${missing[*]}"
  sudo pacman -S --noconfirm --needed "${missing[@]}"
}

# Install AUR packages via paru (skips already-installed ones).
paru_install() {
  local missing=()
  local pkg
  for pkg in "$@"; do
    if is_aur_installed "$pkg"; then
      log_skip "$pkg already installed"
    else
      missing+=("$pkg")
    fi
  done
  [[ ${#missing[@]} -eq 0 ]] && return 0

  log_info "Installing via paru: ${missing[*]}"
  paru -S --noconfirm --needed "${missing[@]}"
}
