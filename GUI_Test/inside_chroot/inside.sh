#!/bin/bash
#  Commentaries
#  * This script is intended to live inside chroot
#  so, do not run this script unless you know what
#  are you doing, because is running automatic
#
#

# Variables


# Functions




# Main

dialog --backtitle "MeinArchInstaller by" \
        --title "HOW TO USE THIS" \
        --msgbox "Just write the direction where the file region are, based on the two windows above text region.\nDO NOT PRESS OK IF YOU HAVE NOT SELECTED YOUR REGION\n\nWith TAB key you can change between windows and buttons" 0 0

dialog --backtitle "MeinArchInstaller by" \
        --title "Note" \
        --msgbox "If you don't know, just write UTC next to /usr/share/zoneinfo/\nAnd it looks like this:\n/usr/share/zoneinfo/UTC" 0 0


region=$(dialog --title "Select your region" \
                --stdout \
                --fselect /usr/share/zoneinfo/  14 70)
echo "Your region: ${region}"



