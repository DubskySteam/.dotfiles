echo '###########################'
echo 'SCRIPT TESTED ON MANJARO 22'
echo '###########################'
echo GitHub::Repo = https://github.com/DubskySteam/.dotfiles

echo '> Checking OS'
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

echo '!!! TO CONTINUE YOU NEED ROOT PERMISSIONS !!!'
if [ $MYOS = "Manjaro" ] || [ $MYOS = "ARCH" ]
then
	echo "> Checking for updates"
	pamac update upgrade
	echo "> Installing: QoL Tools"
	pamac install stow screenfetch net-tools wget gpg
	echo "> Installing: Languages & Environments"
	pamac install git neovim python3 gcc jdk17-openjdk nodejs
	echo "> Creating symlinks"
	stow nvim/
fi
