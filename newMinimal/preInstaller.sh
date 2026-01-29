#!/bin/bash

# Variables
intelBased="intel-ucode intel-media-driver vulkan-intel" # libva-intel-driver if old intel driver is needed
amdBased="amd-ucode"
modules="dkms linux-headers"
dualBoot="os-prober"
bsdLike="less inetutils bind lsof strace sysfsutils man-db man-pages"
utilities="vim nano wget rsync git dialog htop fastfetch tlp" # tmux fzf
core="base linux linux-firmware grub efibootmgr networkmanager base-devel bash-completion"

intelAMDselection=""
packages="$core $modules $dualBoot $bsdLike $utilities"

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

# Main
echo "Before Installation"
while true; do
    echo "Are you using Intel or AMD?"
    echo " 1) Intel"
    echo " 2) AMD"
    echo -n "Option: "
    read intelAMDselection
    if [[ "$intelAMDselection" == "1" || "$intelAMDselection" == "2" ]]; then
        break
    fi
    echo "Wrong selection"
    echo "Please."
done

case $intelAMDselection in
    1)
    packages="$packages $intelBased"
        ;;
    2)
    packages="$packages $amdBased"
        ;;
esac

while true; do
clear
    echo "Partition Drives"
    echo "This part is manual"
    bash
    echo -n "Are you sure? [Y/N]: "
    read partDrivesSure
    if [[ "$partDrivesSure" == "Y" || "$partDrivesSure" == "y" ]]; then
        break
    fi
done

pacman -Sy archlinux-keyring
pacstrap -K $packages
genfstab -U /mnt >> /mnt/etc/fstab

cp installer.sh /mnt
arch-chroot /mnt bash /installer.sh

clear
echo "Finishing!"
loadingFunction
umount -R /mnt

echo "Use PostInstaller for setting up and install everything else"
