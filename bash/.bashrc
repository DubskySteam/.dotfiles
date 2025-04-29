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

# Function to create a new tmux session for each terminal/SSH login
start_tmux() {
    if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        if [ -n "$SSH_CONNECTION" ]; then
            # Create a new session for each SSH connection
            tmux new-session -s ssh_$(date +%s)
        else
            # Create a new session for local terminals
            tmux new-session -s local_$(date +%s)
        fi
    fi
}

# Call the start_tmux function
start_tmux

# Initialize starship prompt
eval "$(starship init bash)"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
