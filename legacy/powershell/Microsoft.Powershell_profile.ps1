Clear-Host
Set-Alias -Name g -Value git
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim

function cdh {
    Set-Location $HOME
}

function cdg {
    Set-Location $HOME/github
}

function cdd {
    Set-Location $HOME/.dotfiles
}

function wingrade {
    winget upgrade --all
}

function la {
    eza --icons --all @args
}

function ll {
    eza --icons --long --all @args
}

fnm env --use-on-cd | Out-String | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\zash.omp.json" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })
