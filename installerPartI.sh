#!/bin/bash
paquetes="dkms linux-headers broadcom-wl-dkms base base-devel linux linux-firmware nano networkmanager htop fastfetch grub os-prober efibootmgr"

echo "Este script fué creado para ser ejecutado en el entorno live de Arch Linux"
echo "Por favor, si no es así, cancele la instalación en este instante con CTRL-C"
echo "Pulse Enter si es que está en una instalación limpia de Arch Linux"
read

pacstrap -K /mnt $paquetes
genfstab -U /mnt >> /mnt/etc/fstab
cp ../MeinArchInstaller /mnt

echo "Cambiando al entorno de chroot"
sleep 2
echo
echo
echo "Por favor, abra el archivo installerPartII.sh para continuar"
arch-chroot /mnt

echo "Pulse ENTER"
read
rm /mnt/installerPartII.sh
clear
echo "Finalizado..."
echo "Por favor, escriba el siguiente comando y reinicie la máquina"
echo "umount -R /mnt && reboot now"
