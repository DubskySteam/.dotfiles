#!/bin/bash

C_CLEAR='\033[0m'
C_RED='\033[0;31m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'

echo 'GitHub::Repo = https://github.com/DubskySteam/.dotfiles'

printf "> ${C_CYAN}Setting up:${C_CLEAR} zsh\n"
chsh -s /usr/bin/zsh

printf "> ${C_CYAN}Setting up:${C_CLEAR} dotfiles\n"
stow nvim
stow tmux
stow zsh
stow waybar
rm ~/.config/hypr/hyprland.lua
stow hyprland
stow hyprpaper
stow wofi
stow kitty
