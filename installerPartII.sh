#!/bin/bash
#Archivo Instalador de Arch Linux Base, con todo configurado para que esté listo para usarse

# =====================
# VARIABLES
# =====================
disco=""
opcion=""
nombreMaquina=""
nombreUser=""
discoMBRorGPT=""

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

# Paquetes necesarios
pacman -Sy --noconfirm grub os-prober networkmanager sudo

# =====================
# MENU INTERACTIVO
# =====================
while true; do
    clear
    echo "Seleccione una opción:"
    echo "1) Escoger entre MBR o GPT"
    echo "2) Nombre de la máquina"
    echo "3) Nombre de usuario"
    echo "4) Activar SUDO automáticamente"
    echo "5) Configurar GRUB con OS Prober"
    echo "6) Continuar"
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
        sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        echo "SUDO activado para usuarios en el grupo wheel."
        sleep 2
        ;;
    5)
        sed -i '/GRUB_DISABLE_OS_PROBER=/d' /etc/default/grub
        echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
        echo "OS Prober habilitado en GRUB."
        sleep 2
        ;;
    6)
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

clear
echo "===================================="
echo " Instalación de Arch Linux completada"
echo "===================================="
sleep 2
exit
