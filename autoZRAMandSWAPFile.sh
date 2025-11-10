#/bin/bash
user=$(whoami)
clear
echo
echo "Bienvenido a este instalador automatico de ZRAM y SWAPFile"
sleep .5
echo "Comprobando si es superusuario"
sleep 1
if [ "$user" != "root" ]; then
    echo "El usuario es $user, por favor ejecute este script como superusuario (sudo).. "
    sudo "$0" "$@"
    exit
fi

echo
echo "SuperUsuario detectado, continuando..."
echo
sleep 1
clear

echo

sudo pacman -Syu --needed --noconfirm zram-generator

echo "[zram0]
zram-size = ram * 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap" > /etc/systemd/zram-generator.conf


sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile
sudo mkswap /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

sleep 1
echo "Terminado, reinicie la maquina por favor..."
echo
sleep 1
echo "Presione ENTER para terminar y reiniciar"
sudo reboot now
