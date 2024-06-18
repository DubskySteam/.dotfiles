#!/bin/bash

C_CLEAR='\033[0m'
C_RED='\033[0;31m'
C_CYAN='\033[0;36m'
C_GREEN='\033[0;32m'

echo 'GitHub::Repo = https://github.com/DubskySteam/.dotfiles'

printf "> ${C_CYAN}Updating:${C_CLEAR} Keyring\n"
sudo pacman -Sy --noconfirm archlinux-keyring

printf "> ${C_CYAN}Updating:${C_CLEAR} Mirrors\n"
sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

printf "> ${C_CYAN}Updating:${C_CLEAR} System\n"
sudo pacman -Syu --noconfirm

printf "${C_RED}> The script will now install packages. Are you sure you want to do this?${C_CLEAR}\n"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) printf "${C_GREEN}Proceeding with installation...${C_CLEAR}\n"; break;;
        No ) printf "${C_RED}Installation aborted.${C_CLEAR}\n"; exit;;
    esac
done

printf "> ${C_CYAN}Installing:${C_CLEAR} Essentials\n"
sudo pacman -S --noconfirm stow tmux neofetch wget gpgme eza base-devel cmake make wofi ninja gradle

printf "> ${C_CYAN}Installing:${C_CLEAR} QoL Tools\n"
sudo pacman -S --noconfirm mpv nomacs btop

printf "> ${C_CYAN}Installing:${C_CLEAR} Languages & Environments\n"
sudo pacman -S --noconfirm git neovim python gcc jdk17-openjdk

printf "> ${C_CYAN}Creating symlinks${C_CLEAR}\n"
stow nvim
stow tmux
stow bash
stow waybar
stow hypr
stow git
