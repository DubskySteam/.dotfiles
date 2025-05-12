# .dotfiles

## Installation

### Install scripts

- **Arch**
   ```sh
   sudo chmod +x ./install.sh
   sudo ./install.sh
   ```

- **Windows**
   
   1. **Install PowerShell 7 if required**
      ```ps1
      winget install --id Microsoft.Powershell --source winget
      ```

   2. **Install necessary programs**
      ```ps1
      .\win_install_req.ps1
      ```

   3. **Create symlinks** 
      ```ps1
      .\win_install.ps1
      ```

### Manual

**Requirements:**
- git
- stow (linux only)
- powershell 7 (windows only)

1. **Clone the Repository**
   ```sh
   cd $HOME
   git clone https://github.com/dubskysteam/.dotfiles
   cd .dotfiles
   ```

2. **Create symlinks**

   **Linux / Arch**
   ```sh
   stow X  # Replace X with the folder name you want to symlink
   ```

   **Windows**
   ```sh
   New-Item -Path PATH_FROM_DOTFILES -ItemType SymbolicLink -Value PATH_TO_TARGET_DIR
   ```

## Included
##### Tested Distros
```
Arch (Tested: 11.05.2025)
Windows 11 (Tested: 11.05.2025)
```

##### Desktop Enviroment
Linux
```sh
[Desktop] i3
[Top Bar] waybar
```

Windows
```sh
[Desktop] Komorebi
[Top Bar] Yasb
```

##### Programming Languages
```
Zig
Rust
C/C++
NodeJS
Python 3
Java 11 | 17 | 21
```

##### Terminal
Emulators
```sh
Wezterm
```

Shells
```sh
[Linux] Bash
[Win 11] PowerShell 7
```

Multiplexer
```sh
[Linux] Tmux
[Win 11] Wezterm internal
```

##### Development
```sh
Git
Gpg
LazyGit
GitHub CLI
```

##### Editors
```sh
NeoVim
VS Code
```

##### Quality of Life
```sh
stow # A symlink tool
screenfetch # Neofetch alternative
```
