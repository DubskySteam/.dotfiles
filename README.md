# .dotfiles


## Installation

### Manual

1. **Clone the Repository**
   ```sh
   cd $HOME
   git clone https://github.com/dubskysteam/.dotfiles
   cd .dotfiles
   ```

2. **Create symlinks**
   ```sh
   stow X  # Replace X with the folder name you want to symlink
   ```

### Install scripts

- **Arch**
   ```sh
   sudo chmod +x ./Arch_Run.sh
   sudo ./Arch_Run.sh
   ```

- **Windows** (run it in powershell with admin permissions)
   ```ps1
   .\install.ps1
   ```


## Supported
##### Supported Distros
```
Arch (Tested: 17.06.2024)
Windows 23H2 (Tested: 17.06.2023)
EndeavourOS (Tested: 06.11.2023)
```
##### Languages
```
C/C++
Java 17
NodeJS 16 (Latest on Arch)
Python 3
```
##### Terminals
```sh
Alacritty # A cross-platform, GPU-accelerated terminal emulator
Wezterm # A GPU-accelerated cross-platform terminal emulator and multiplexer
Kitty # A fast, feature-rich, GPU based terminal emulator
PowerShell # A cross-platform task automation and configuration management framework from Microsoft
```
##### Quality of Life
```sh
git # A distributed version control system for tracking changes in source code during software development
tmux # A terminal multiplexer for Unix-like operating systems
gpg # GNU Privacy Guard, a data encryption and decryption program
curl # A command-line tool for transferring data specified with URL syntax
wget # A free utility for non-interactive download of files from the web
stow # A symlink farm manager
neovim # A hyperextensible text editor based on Vim
screenfetch # Neofetch alternative
gh # GitHub CLI, a powerful, official command-line tool for interacting with GitHub from your terminal
```
