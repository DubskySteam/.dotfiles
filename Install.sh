echo '#########################################'
echo 'SCRIPT TESTED ON DEBIAN 11 + UBUNTU 20.04'
echo '#########################################'
echo GitHub::Repo = https://github.com/DubskySteam/.dotfiles

echo Checking OS
MYOS=$(hostnamectl | awk '/Operating/ { print $3 }')
OSVERSION=$(hostnamectl | awk '/Operating/ { print $4 }')

echo !!! TO CONTINUE YOU NEED ROOT PERMISSIONS !!!
if [ $MYOS = "Ubuntu" ]
then
        echo "Checking for updates"
        apt-get update
        apt-get upgrade
        echo "Installing: Qualify of Life tools"
		apt-get install stow screenfetch net-tools curl wget gpg -y
        echo "Installing: Languages & Environments"
        apt-get install git neovim python2 python3 gcc g++ openjdk-17-jdk openjdk-17-jre -y
        curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        apt install -y nodejs
        echo "Creating symlinks"
        stow bash/
        stow nvim/
fi
