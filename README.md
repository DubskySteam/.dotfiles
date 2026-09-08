# ⚡ Dotfiles

Personal dotfiles for an Arch Linux + Hyprland setup.
Current iteration: v4

## 📦 What's Included

| Package   | Description                              |
|-----------|------------------------------------------|
| `git`     | Git config                               |
| `hyprland`| Hyprland (Lua config) + hyprpaper        |
| `kitty`   | Terminal                                 |
| `nvim`    | Neovim                                   |
| `tmux`    | Tmux                                     |
| `waybar`  | Status bar                               |
| `wofi`    | App launcher                             |
| `zsh`     | Shell config, aliases & plugins          |
| `systemd` | User service for the active shell       |
| `sddm`    | Custom Tokyo Night login screen          |

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/dubskysteam/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. One-command setup

On a fresh Arch installation, the interactive bootstrap installs packages,
links the dotfiles, configures the selected shell profile, and optionally
installs the custom SDDM login screen.

```bash
./bootstrap.sh
```

The bootstrap asks before privileged changes and supports:

```bash
./bootstrap.sh --profile quickshell
./bootstrap.sh --profile waybar --skip-update --no-sddm
```

### 3. Maintenance Commands

The bootstrap calls these lower-level scripts automatically. Run them directly
when only one part of the setup needs to be repeated.

#### Install Packages

Installs or updates the Arch packages used by the dotfiles, including both
shell profile backends.

```bash
./install.sh
```

Options:

* `--skip-update` — skip the keyring/mirror/system update phase
* `--assume-yes` — answer yes to all prompts (for automation)

#### Link Dotfiles

Restows the config packages into `~`, initializes the profile launcher, and
offers to set `zsh` as your login shell.

```bash
./setup.sh
```

To link only specific packages:

```bash
./setup.sh nvim tmux zsh
```

### 4. Manual Stow (Alternative)

If you prefer linking packages manually:

```bash
cd ~/.dotfiles
stow git hyprland kitty nvim systemd tmux waybar wofi zsh
```

The setup script also installs the profile launcher at
`~/.local/bin/dotfiles-profile` and manages the user service that starts the
selected shell. It fixes the active profile at once, so it is also the profile
used after the next reboot.

```bash
dotfiles-profile current
dotfiles-profile set quickshell
dotfiles-profile menu
```

---

## ⌨️ Custom Keybindings

Configured in `hyprland/.config/hypr/hyprland.lua` (mod key = `SUPER`):

* **`SUPER + D`** — Open Wofi (app launcher)
* **`SUPER + Q`** — Open terminal (kitty)
* **`SUPER + C`** — Close active window
* **`SUPER + M`** — Exit/restart Hyprland session
* **`SUPER + E`** — Open file manager (dolphin)
* **`SUPER + R`** — Reload hyprpaper
* **`SUPER + F5`** — Restart waybar
* **`SUPER + V`** — Toggle floating window
* **`SUPER + P`** — Toggle pseudo-tiling
* **`SUPER + SHIFT + J`** — Toggle split (dwindle)
* **`SUPER + [H/J/K/L]`** — Move focus
* **`SUPER + [1-0]`** — Switch workspace
* **`SUPER + SHIFT + [1-0]`** — Move window to workspace
* **`SUPER + S`** — Toggle scratchpad workspace

## 🛠 Scripts

| Script      | Purpose                                        |
|-------------|------------------------------------------------|
| `bootstrap.sh` | Interactive fresh-Arch setup coordinator |
| `install.sh`   | Install packages and system prerequisites |
| `setup.sh`     | Stow dotfiles and set the default shell   |
| `lib.sh`       | Shared helpers (sourced, not run directly) |

## Shell Profiles

`waybar` is the established profile. `quickshell` is an event-driven QtQuick
bar with reactive Hyprland workspaces, clock, title, memory/load widgets, and a
profile menu. Only the selected backend runs; the profile is persisted outside
Git so changing it does not switch branches or rewrite the repository.

The SDDM login screen exposes both profiles. Selecting one chooses the matching
Hyprland session and persists that choice before the desktop starts.
