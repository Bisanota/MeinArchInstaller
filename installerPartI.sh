#!/bin/bash
paquetes="dkms linux-headers broadcom-wl-dkms base base-devel linux linux-firmware nano networkmanager htop fastfetch grub os-prober efibootmgr zram-generator"
echo "ADVERTENCIA"
echo "SE REQUIERE CONEXIÓN A INTERNET PARA ESTA INSTALACIÓN"
sleep 2
echo "Este script fué creado para ser ejecutado en el entorno live de Arch Linux"
sleep 1
echo "Por favor, si no es así, cancele la instalación en este instante con CTRL-C"
sleep 1
echo "La parte de la preparación de Discos dependen plenamente del usuario
por lo que, si aún no se ha montado las particiones según lo deseado
echo en mnt, cancele la instalación en este instante con CTRL-C"
sleep 1
echo "Para más información, lea el archivo README"
echo "Pulse Enter si es que cumple las condiciones"
read

installArch="pacstrap -K /mnt $paquetes"
intentos=0
intentosMax=5
haFuncionado=0

echo "Empezando la instalación"
while [ $intentos -le $intentosMax ] ; do

    $installArch && break
    echo "Ha fallado :c"
    intentos=$((intentos + 1))
    haFuncionado=1
done

if [ $haFuncionado == 0 ]; then


genfstab -U /mnt >> /mnt/etc/fstab

cp installerPartII.sh /mnt
echo "Cambiando al entorno de chroot y ejecutando la parte II"
sleep 2
arch-chroot /mnt bash /installerPartII.sh
rm  /mnt/installerPartII.sh
clear
echo "Finalizado..."
umount -R /mnt
bucleSleepNum=0
bucleSleepMax=80
echo "Por favor, deconecte el USB en cuanto la PC se apague"
while [ $bucleSleepNum -le $bucleSleepMax ]; do
echo -n .
sleep 0.025
bucleSleepNum=$((bucleSleepNum + 1))
done
echo
sleep 1
reboot now

    else
echo "La instalación ha fallado :("
sleep 1
echo "Por favor, vuelva a intentarlo"

fi
