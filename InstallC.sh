echo '#########################################'
echo 'SCRIPT TESTED ON DEBIAN 11 + UBUNTU 20.04'
echo '#########################################'
echo GitHub::Repo = https://github.com/DubskySteam/dotfiles
echo Installing "C/C++ Programming" packages

echo Checking OS
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

echo Need ROOT permissions
if [ $MYOS = "Ubuntu" ] then
	if [ $UID -ne 0 ]; then
		apt-get install gcc g++ -y
	fi
fi
