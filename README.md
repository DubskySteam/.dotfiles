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

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/dubskysteam/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install Packages

Runs a full Arch Linux setup: keyring, mirrors, system update, essential
packages, the AUR helper `paru`, and the app stack (fonts, tools, etc.).

```bash
./install.sh
```

Options:

* `--skip-update` — skip the keyring/mirror/system update phase
* `--assume-yes` — answer yes to all prompts (for automation)

### 3. Link Dotfiles

Stows the config packages into `~` and offers to set `zsh` as your login shell.

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
stow git hyprland kitty nvim tmux waybar wofi zsh
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
| `install.sh`| Install packages & system prerequisites       |
| `setup.sh`  | Stow dotfiles & set default shell             |
| `lib.sh`    | Shared helpers (sourced, not run directly)    |
