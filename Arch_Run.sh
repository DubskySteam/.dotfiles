#!/bin/bash
echo '############################'
echo 'SCRIPT TESTED ON ENDEAVOUROS'
echo '############################'
echo GitHub::Repo = https://github.com/DubskySteam/.dotfiles

echo '> Updating: Keyring'
sudo pacman -Sy --noconfirm archlinux-keyring manjaro-keyring endeavouros-keyring

echo '> Updating: Mirrors'
if [ "$(grep -Fxq 'ID=arch' /etc/os-release)" ]; then
    sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
elif [ "$(grep -Fxq 'ID=manjaro' /etc/os-release)" ]; then
    sudo pacman-mirrors --fasttrack && sudo pacman -Syy
elif [ "$(grep -Fxq 'ID=endeavouros' /etc/os-release)" ]; then
    sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
fi

echo '> Updating: System'
sudo pacman -Syu --noconfirm

echo "> Installing: QoL Tools"
sudo pamac install stow tmux screenfetch net-tools wget gpg

echo "> Installing: Languages & Environments"
sudo pamac install git neovim python3 gcc jdk17-openjdk nodejs

echo "> Installing: Terminal"
sudo pamac install alacritty

echo "> Creating symlinks"
stow nvim
stow tmux
stow alacritty
