# =============================================================================
# ~/.zshrc - Main Entry Point
# =============================================================================

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# 1. Konfigurationen laden (gelten überall: Terminal & Tmux)
source ~/.config/zsh/general.zsh
source ~/.config/zsh/aliases.zsh
export GPG_TTY=$(tty)

# 2. Tmux Auto-Start
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    session="$(basename "$PWD")-$$"
    tmux new-session -s "$session"
    trap 'tmux kill-session -t "$session" 2>/dev/null' EXIT HUP
fi
