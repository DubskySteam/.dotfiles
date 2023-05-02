@echo off
set /p cpath="Path to local .dotfiles repo >> "
echo Symlinking gitconfig
mklink C:\Users\%USERNAME%\.gitconfig %cpath%\git\.gitconfig
echo Checking PS7 Path
if exist C:\Users\%USERNAME%\Documents\Powershell (
	echo Folder exists already	
) else (
	echo Creating folder
	mkdir C:\Users\%USERNAME%\Documents\Powershell
)
echo Symlinking PS7
mklink C:\Users\%USERNAME%\Documents\Powershell\Microsoft.PowerShell_profile.ps1 %cpath%\ps7\Microsoft.PowerShell_profile.ps1
