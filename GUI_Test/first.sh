#!/bin/bash
#  Comments:
#  * This script is intended to manage everything else, 
#  and install all dependencies before the first start.
#  So, I almost forgot this, IS INTENDED JUST TO RUN
#  ON LIVE ENVIRONMENT, IS JUST THE FIRST INSTALLATION.

# Variables

# Functions

CancelledInstaller() {
dialog --backtitle "MeinArchInstaller by Bisanota" \
    	--title "Installation Canceled :("\
	--msgbox "Installation was cancelled by user" 10 50
	clear
	exit 0
}

ContinueInstaller() {
(for i in $(seq 1 100); do
    echo $i
    sleep 0.05
done) | dialog --backtitle "MeinArchInstaller by Bisanota" \
    --title "Wait" --gauge "LOADING\n BE PATIENT!!" 10 50 0
    dialog --msgbox "Press OK for continue" 5 60
    clear
    echo "Starting menu"
    for i in $(seq 1 10); do
    	echo -n "."
    	sleep 0.05
    done
    echo
    clear       
    bash menu.sh
}

# Code

dialog  --backtitle "MeinArchInstaller by Bisanota" \
    	--title "Welcome" \
	--msgbox "Welcome to this easy ArchLinux installer made by Bisanota. \n\nThis part is just to install base system, so, is supposed to run this on a live environment. Otherwise, please \n CLOSE THIS AND DO NOT FOLLOW THE INSTALLER" 20 50 \
	--and-widget --yesno "Are you running this on a Live environment? \n\nBE CAREFUL IF THIS IS NOT THE CASE\n\nYou can press Esc twice to cancel, or chose CANCEL button." 15 40

case $? in
  0) ContinueInstaller ;;
  1|255) CancelledInstaller ;;
esac