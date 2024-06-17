#Requires -RunAsAdministrator

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

Write-Host $art
Write-Host "This script will install packages." -ForegroundColor Red

if (-not (Test-Admin)) {
    Write-Host "This script must be run as an administrator!" -ForegroundColor Red
    exit
}

$continue = Read-Host "Do you want to continue with the installation of packages? (y/n)"
if ($continue -ne 'y') {
    Write-Host "Installation aborted."
    exit
}

Write-Host "Installing packages using winget..."

Write-Host "Installing: VS Code"
winget install --id Microsoft.VisualStudioCode -e
Write-Host "Installing: RipGrep"
winget install BurntSushi.ripgrep.MSVC
Write-Host "Installing: Eza"
winget install eza-community.eza

Write-Host "Packages installation completed."
