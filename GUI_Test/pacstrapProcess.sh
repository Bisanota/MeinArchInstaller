#!/bin/bash
#  Comments:
#  * This script is for install some packages through pacstrap

# Variables
packages="base base-devel linux linux-firmware nano networkmanager dialog git less bash-completion"
tries=0
maxTries=5
haFuncionado=0
installArch="pacstrap -K /mnt $packages"

# Functions


# Code

while [ $tries -le $maxTries ] ; do

    $installArch && break
    echo "Ha has failed :c"
    intentos=$((intentos + 1))
    haFuncionado=1
done

if [ $haFuncionado == 0 ]; then

genfstab -U /mnt >> /mnt/etc/fstab

cp -r ./inside_chroot /mnt
arch-chroot /mnt bash ./inside_chroot/installerOnArchChroot.sh
rm  /mnt/installerPartII.sh
clear
umount -R /mnt

fi

