$UserProfile = [System.Environment]::GetFolderPath('UserProfile')

$links = @(
    @{
        LinkPath = "$UserProfile\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
        TargetPath = "$UserProfile\github\.dotfiles\powershell\Microsoft.PowerShell_profile.ps1"
    },
    @{
        LinkPath = "$UserProfile\AppData\Local\nvim"
        TargetPath = "$UserProfile\github\.dotfiles\nvim\.config\nvim"
    },
    @{
        LinkPath = "$UserProfile\.wezterm.lua"
        TargetPath = "$UserProfile\github\.dotfiles\wezterm\.config\wezterm\.wezterm.lua"
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
