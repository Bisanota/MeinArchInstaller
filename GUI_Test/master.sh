#!/bin/bash
#  Comments:
#  * This script is intended to manage everything else, 
#  and install all dependencies before the first start.
#  So, I almost forgot this, IS INTENDED JUST TO RUN
#  ON LIVE ENVIRONMENT, IS JUST THE FIRST INSTALLATION.
# Variables
dependencies="dialog git"
# Functions


# Code
clear
echo "Warning, you've started the installing process"
echo "If you have run this script before, then, press Ctrl-C and just run first.sh script, otherwise, just press Enter button"
echo "Press Enter to continue"
read
pacman -Sy archlinux-keyring
pacman -Sy $dependencies

bash first.sh

