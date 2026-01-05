#!/bin/bash
#  Comments:
#  * This script is just to choose something.

# Variables


# Functions
CancelledInstaller() {
dialog --title "Installation Canceled :("\
	--msgbox "Installation was cancelled by user" 10 50
	clear
	exit 0	
}

Partitioning() {
clear
echo "For multiple reasons, this part is manually."
echo "Note: Maybe some day this will be more easy."
echo "So, create, modify, mount whatever you want in /mnt ."
echo "Press some key to continue. Remember to write exit to exit"
read
bash
}

InstallerOnArchChroot() {
bash pacstrapProcess.sh
}

# Code

while true; do

choice=$(dialog \
    --backtitle "MeinArchInstaller by Bisanota" \
    --title "Menu" \
    --clear \
    --cancel-label "You Can't Scape HAHA" \
    --menu "Choose an option:" 12 45 4 \
    "1" "Make and Mount Partitions (Manual)" \
    "2" "Start Installation" \
    "3" "Exit" \
    3>&1 1>&2 2>&3 3>&-)

case $choice in
    1) Partitioning;;
    2) InstallerOnArchChroot;;
    3|255) CancelledInstaller;;
esac

done
