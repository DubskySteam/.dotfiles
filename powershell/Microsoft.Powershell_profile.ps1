Set-Alias -Name g -Value git
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name cdh -Value "cd $HOME"

function la {
    eza --icons --all @args
}

function ll {
    eza --icons --long --all @args
}

function Show-ASCIIArt {
@"

 ______    ___  ____   ___ ___  ____  ____    ____  _     
|      |  /  _]|    \ |   |   ||    ||    \  /    || |    
|      | /  [_ |  D  )| _   _ | |  | |  _  ||  o  || |    
|_|  |_||    _]|    / |  \_/  | |  | |  |  ||     || |___ 
  |  |  |   [_ |    \ |   |   | |  | |  |  ||  _  ||     |
  |  |  |     ||  .  \|   |   | |  | |  |  ||  |  ||     |
  |__|  |_____||__|\_||___|___||____||__|__||__|__||_____|
                                                          

"@
}
Show-ASCIIArt

fnm env --use-on-cd | Out-String | Invoke-Expression
