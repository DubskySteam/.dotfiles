# https://github.com/DubskySteam/.dotfiles

# Source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source exports
if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi

# Source keybinds
if [ -f ~/.bash_keybinds ]; then
    . ~/.bash_keybinds
fi

# Start tmux if not already running and if not in a tmux session
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new-session
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
