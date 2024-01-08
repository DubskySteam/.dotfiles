[[ $- != *i* ]] && return

# Tf ~/.bashrc ]] && . ~/.bashrcmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# Aliases
alias ls='eza --icons --color --long --all'
alias ll='ls'
alias g='git'
alias vi='nvim'
alias cls='clear'
alias pcli='protonvpn-cli'
alias fetch='neofetch'
alias grep='grep --color=auto'
alias h='cd $HOME'
PS1='[\u@\h \W]\$ '
