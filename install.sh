#!/bin/bash

C_CLEAR='\033[0m'
C_RED='\033[0;31m'
C_CYAN='\033[0;36m'

echo '###################################'
echo 'SCRIPT TESTED ON ARCH LINUX 6.6.10'
echo '###################################'
echo 'GitHub::Repo = https://github.com/DubskySteam/.dotfiles'

printf "> ${C_CYAN}Updating:${C_CLEAR} Keyring\n"
sudo pacman -Sy --noconfirm archlinux-keyring manjaro-keyring endeavouros-keyring

printf "> ${C_CYAN}Updating:${C_CLEAR} Mirrors\n"
if [ "$(grep -Fxq 'ID=arch' /etc/os-release)" ]; then
    sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
elif [ "$(grep -Fxq 'ID=manjaro' /etc/os-release)" ]; then
    sudo pacman-mirrors --fasttrack && sudo pacman -Syy
elif [ "$(grep -Fxq 'ID=endeavouros' /etc/os-release)" ]; then
    sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
fi

printf "> ${C_CYAN}Updating:${C_CLEAR} System\n"
sudo pacman -Syu --noconfirm

printf "> ${C_RED}The script will now install packages. Are you sure you want to do this?\n${C_CLEAR}"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "alright...."; break;;
        No ) exit;;
    esac
done

echo "> Installing: Essentials"
sudo pacman -S --noconfirm stow tmux neofetch wget gpgme eza base-devel cmake make wofi ninja gradle

echo "> Installing: QoL Tools"
sudo pacman -S --noconfirm mpv nomacs btop

echo "> Installing: Languages & Environments"
sudo pacman -S --noconfirm git neovim python3 gcc jdk17-openjdk

echo "> Creating symlinks"
stow nvim
stow tmux
stow bash
stow waybar
stow hypr
