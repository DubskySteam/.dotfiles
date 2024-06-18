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

Write-Host $art -ForegroundColor Orange

if (-not (Test-Admin)) {
    Write-Host "This script must be run as an administrator!" -ForegroundColor Red
    exit
}

$UserProfile = [System.Environment]::GetFolderPath('UserProfile')

$links = @(
    @{
        LinkPath = "$UserProfile\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        TargetPath = "$UserProfile\.dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
    },
    @{
        LinkPath = "$UserProfile\AppData\Local\nvim"
        TargetPath = "$UserProfile\.dotfiles\nvim\.config\nvim"
    },
    @{
        LinkPath = "$UserProfile\.wezterm.lua"
        TargetPath = "$UserProfile\.dotfiles\wezterm\.config\wezterm\.wezterm.lua"
    }
)

foreach ($link in $links) {
    $LinkPath = $link.LinkPath
    $TargetPath = $link.TargetPath

    if (-Not (Test-Path -Path $TargetPath)) {
        Write-Error "The target path '$TargetPath' does not exist."
        continue
    }

    try {
        if (Test-Path -Path $LinkPath) {
            Remove-Item -Path $LinkPath -Recurse -Force
        }
        New-Item -Path $LinkPath -ItemType SymbolicLink -Value $TargetPath
        Write-Output "Symbolic link created successfully: $LinkPath -> $TargetPath"
    } catch {
        Write-Error "Failed to create symbolic link: $_"
    }
}
