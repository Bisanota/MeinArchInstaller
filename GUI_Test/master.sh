#!/bin/bash
#  Comments:
#  * This script is intended to manage everything else, 
#  and install all dependencies before the first start.
#  So, I almost forgot this, IS INTENDED JUST TO RUN
#  ON LIVE ENVIRONMENT, IS JUST THE FIRST INSTALLATION.
# Variables
dependencies="dialog"
# Functions


# Code
pacman -Sy $dependencies

