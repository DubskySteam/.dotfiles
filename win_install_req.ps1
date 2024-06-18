$art = @"

      _         _           _                   _         _     __  _  _            
     | |       | |         | |                 | |       | |   / _|(_)| |           
   __| | _   _ | |__   ___ | | __ _   _      __| |  ___  | |_ | |_  _ | |  ___  ___ 
  / _` || | | || '_ \ / __|| |/ /| | | |    / _` | / _ \ | __||  _|| || | / _ \/ __|
 | (_| || |_| || |_) |\__ \|   < | |_| |  _| (_| || (_) || |_ | |  | || ||  __/\__ \
  \__,_| \__,_||_.__/ |___/|_|\_\ \__, | (_)\__,_| \___/  \__||_|  |_||_| \___||___/
                                   __/ |                                            
                                  |___/                                             

"@

function Test-Admin {
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
return $principal.IsInRole($adminRole)
}

Write-Host $art -ForegroundColor Cyan

if (-not (Test-Admin)) {
    Write-Host "This script must be run as an administrator!" -ForegroundColor Red
    exit
}

$UserProfile = [System.Environment]::GetFolderPath('UserProfile')

$continue = Read-Host "Do you want to continue with the installation of packages? (y/n)"
if ($continue -ne 'y') {
    Write-Host "Installation aborted." -ForegroundColor Red
    exit
}

Write-Host "> Installing packages using winget..." -ForegroundColor Yellow

Write-Host "Installing: VS Code"
winget install --id Microsoft.VisualStudioCode -e
Write-Host "Installing: RipGrep"
winget install BurntSushi.ripgrep.MSVC
Write-Host "Installing: Eza"
winget install eza-community.eza
Write-Host "Installing: NeoVim"
winget install Neovim.Neovim
Write-Host "Installing: WezTerm"
winget install wez.wezterm
Write-Host "Installing: oh-my-posh"
winget install JanDeDobbeleer.OhMyPosh -s winget

Write-Host "> Creating environment variables" -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable("POSH_THEMES_PATH", "$env:UserProfile\AppData\Local\Programs\oh-my-posh\themes", [System.EnvironmentVariableTarget]::User)
Write-Output "POSH_THEMES_PATH: $env:POSH_THEMES_PATH"

Write-Host "> Requirement installation complete" -ForegroundColor Green
