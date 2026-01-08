#!/bin/bash
# Debloated Installer with packages I'll use personally

core="base linux linux-firmware grub efibootmgr os-prober networkmanager dkms linux-headers base-devel vim"

echo "Is suppossed partitions are mounted, right?"
echo "Press ctrl-c if you want not to continue, another key for continue"
read

installArch="pacstrap -K /mnt $core"
tries=0
maxTries=5
hasWorked=0

while [ $tries -le $maxTries ] ; do

    $installArch && break
    echo "Has failed :c"
    tries=$((intentos + 1))
    hasWorked=1
done

if [ $hasWorked == 0 ]; then
genfstab -U /mnt >> /mnt/etc/fstab

echo "Next part relies on you"
echo "Good luck"
echo "Copy installerPartII from parent folder"

fi
