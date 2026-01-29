#!/bin/bash

# Variables
HOSTNAME=$(cat /etc/hostname)
loggedAs=$(whoami)

# Functions
loadingFunction() {
echo -n "["
    bucleSleepNum=0
    bucleSleepMax=40
    while [ $bucleSleepNum -le $bucleSleepMax ]; do
    echo -n .
    sleep 0.04
    bucleSleepNum=$((bucleSleepNum + 1))
done
echo "]"
}

rootLogin(){
    if [ "$loggedAs" != "root" ]; then
        echo "You're not superuser!"
        sleep 1
        echo "If you want to continue, press any key."
        echo "Otherwise, press CTRL-C to cancel installation."
        read
        sudo "$0" "$@"
        exit
    else
        echo "You are installing Archlinux."
        sleep 0.5
        echo "Detecting installation method."
        sleep 2
    fi
}



# Main
clear
echo "Welcome to Bisanota's Archlinux installer!!"
sleep 2
echo "Loading!"
loadingFunction

rootLogin


clear
echo "Remember to stay connected to internet in any moment!"
sleep 2
loadingFunction
if [[ "$USER" == "root"  && "$HOSTNAME" == "archiso" ]]; then
    echo "Live Environment Detected!"
    loadingFunction
    bash preInstaller.sh
    sleep 2
else
    echo "Installation Detected!"
    loadingFunction
    bash postInstaller.sh
    sleep 2
fi

echo "If installation has failed, run \"main.sh\" again! :("
echo "Thanks for using this installer :)"
