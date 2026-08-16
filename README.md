# ⚡ Dotfiles


## ⚙️ Installation & Setup

Clone the repository and run the automated setup script to install dependencies and establish symlinks instantly.

### 1. Clone Repository

```bash
git clone https://github.com/dubskysteam/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

```

### 2. Run Auto-Install Script

```bash
chmod +x setup.sh
./setup.sh

```

### 3. Manual Stow (Alternative)

If you prefer linking packages manually:

```bash
cd ~/.dotfiles
stow zsh hypr waybar wofi tmux kitty

```

---

## ⌨️ Custom Keybindings

Here are some of the core bindings configured in `hyprland.conf`:

* **`SUPER + D`** — Open Wofi (App Launcher)
* **`SUPER + Enter`** — Open Terminal
* **`SUPER + Q`** — Close active window
* **`SUPER + Shift + E`** — Exit/Restart Hyprland session
* **`SUPER + [1-9]`** — Switch workspace
