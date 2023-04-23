echo '#########################################'
echo 'SCRIPT TESTED ON DEBIAN 11 + UBUNTU 20.04'
echo '#########################################'
echo GitHub::Repo = https://github.com/DubskySteam/dotfiles
echo Installing "Quality of Life" packages

echo Checking OS
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

echo Need ROOT permissions
if [ $MYOS = "Ubuntu" ]
then
		apt-get install screenfetch git neovim net-tools curl -y
fi
