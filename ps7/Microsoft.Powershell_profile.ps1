oh-my-posh init pwsh --config "https://gist.githubusercontent.com/DubskySteam/bdc2071ded20eddf7328aa5398bbf02a/raw/e98b956c527cdb4bc3d5a01d8940323451a0a6ff/dubsky_custom.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
New-Alias -Name ll -Value ls
New-Alias -Name g -Value git
New-Alias -Name vi -Value nvim
New-Alias -Name vim -Value nvim
New-Alias -Name gcc -Value x86_64-w64-mingw32-gcc
New-Alias -Name 'g++' -Value 'x86_64-w64-mingw32-g++'