#!/bin/bash
#  Comments:
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
sleep 3

clear






#HERE START COPY PASTE
#Archivo Instalador de Arch Linux Base, con todo configurado para que esté listo para usarse

# =====================
# VARIABLES
# =====================
disco=""
opcion=""
nombreMaquina=""
nombreUser=""
discoMBRorGPT=""
chaoticAURconf=0
# =====================
# FUNCIONES
# =====================
confirmar() {
    read -p "$1 [s/N]: " r
    [[ "$r" =~ ^[sS]$ ]]
}

# =====================
# CONFIG INICIAL
# =====================
clear
echo "Mi zona horaria es UTC-5 (America/Guayaquil)."
ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
hwclock --systohc

# Idioma
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Teclado consola (opcional, puedes cambiarlo)
echo "KEYMAP=la-latin1" > /etc/vconsole.conf

# =====================
# MENU INTERACTIVO
# =====================
while true; do
    clear
    echo "Seleccione una opción:"
    echo "1) Escoger entre MBR o GPT"
    echo "2) Nombre de la máquina"
    echo "3) Nombre de usuario"
    echo "4) Agregar ChaoticAUR"
    echo "5) Continuar"
    read -p "> " opcion

    case $opcion in
    1)
        while true; do
            clear
            echo "¿Su disco está en MBR o GPT?"
            echo "1) MBR"
            echo "2) GPT"
            read -p "> " disco
            case $disco in
                1)
                    discoMBRorGPT="grub-install --target=i386-pc /dev/sda"
                    break
                    ;;
                2)
                    discoMBRorGPT="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchBTW"
                    break
                    ;;
                *)
                    echo "Respuesta no válida."
                    sleep 1
                    ;;
            esac
        done
        ;;
    2)
        clear
        read -p "¿Qué nombre desea para la máquina? " nombreMaquina
        ;;
    3)
        while true; do
            clear
            read -p "¿Qué nombre desea para el usuario? " nombreUser
            if id "$nombreUser" &>/dev/null; then
                echo "El usuario ya existe, intente otro."
                sleep 2
            else
                useradd -m -G wheel -s /bin/bash "$nombreUser"
                break
            fi
        done
        ;;
    4)
        pacman-key --recv-key 3056513887B78AEB #--keyserver keyserver.ubuntu.com ## PARTE QUITADA POR PROVOCAR PROBLEMAS
        pacman-key --lsign-key 3056513887B78AEB
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
        echo -e "\n#Multilib\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
        echo -e "\n#Chaotic AUR\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
        ;;
    5)
        clear
        echo "Resumen:"
        echo " - Estilo de partición: $disco"
        echo " - Nombre de máquina: $nombreMaquina"
        echo " - Usuario: $nombreUser"
        if confirmar "¿Desea continuar?"; then
            break
        fi
        ;;
    *)
        echo "Opción inválida."
        sleep 1
        ;;
    esac
done
# =====================
# ACTIVACIÓN DEL GRUPO SUDOERS Y DE OS PROBER
# =====================

        sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        echo "SUDO activado para usuarios en el grupo wheel."
        sleep 2
        sed -i '/GRUB_DISABLE_OS_PROBER=/d' /etc/default/grub
        echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
        echo "OS Prober habilitado en GRUB."
        sleep 2    

# =====================
# CONTRASEÑAS
# =====================
clear
echo "Contraseña para root:"
passwd

echo "Contraseña para $nombreUser:"
passwd "$nombreUser"

# =====================
# HOSTNAME Y HOSTS
# =====================
echo "$nombreMaquina" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $nombreMaquina.localdomain $nombreMaquina
EOF

# =====================
# GRUB & NETWORK
# =====================
echo "Instalando GRUB..."
$discoMBRorGPT
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

echo "[zram0]
zram-size = ram * 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap" > /etc/systemd/zram-generator.conf

clear
echo "===================================="
echo " Instalación de Arch Linux completada"
echo "===================================="
sleep 2
exit


