#!/bin/bash
#Archivo Instalador de Arch Linux Base, con todo configurado para que esté listo para usarse

#VARIABLES
disco=""
opcion=""
nombreMaquina=""
nombreUser=""
contador="0"
#FUNCIONES


#CÓDIGO

 ##Esta parte es fija, puesto a que siempre lo haré en mis máquinas. Son libres de modificar esta parte segun sus necesidades
clear

#entra el entorno de sistema
clear
echo "Mi zona horaria es UTC-5, por lo que este script tiene ese formato de hora"

ln -sf /usr/share/zoneinfo/America/Guayaquil /etc/localtime
hwclock --systohc
sleep 1
#Idioma
clear
echo "Yo quiero que esté en ingles, preferencia personal. Pero en todo caso se puede tranquilamente en otro idioma."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
sleep 2
clear


#Empieza lo verdadero
#Bucle preguntón para asegurarse de escoger bien jaja
while true; do
    clear
    echo "Seleccione una opción:"
    echo "1) Escoger entre MBR o GPT"
    echo "2) Nombre de la máquina"
    echo "3) Nombre de usuario"
    echo "4) Activar SUDO"
    echo "5) Activar Bootloader"
    echo "6) Continuar"
    read opcion


    case $opcion in

    1)


    ##Pregunta si es MBR O GPT
while true; do

    clear
    echo "Se necesita saber si su disco está en MBR o GPT"
    echo "..."
    echo "1) MBR"
    echo "2) GPT"
    read disco

    case $disco in

    1)
        echo
        echo "Su disco está en MBR, por lo que se ajustará e instalara a este sistema :D"
        discoMBRorGPT="grub-install --target=i386-pc /dev/sda"
   	break
	;;
    2)
        echo
        echo "Su disco está en GPT, por lo que se ajustará e instalara a este sistema :D"
        echo
        sleep 1
        discoMBRorGPT="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchBTW"
	break
    ;;
    *)
        echo "Respuesta no válida :("
        sleep 1
    ;;
    esac

done

    ;;
    2)
    #Nombre del host
clear
echo "¿Qué nombre desea para la máquina?"
read nombreMaquina

    ;;
    3)
    clear
if [ "$contador" != "0" ]; then
userdel -r $nombreUser
    contador="1"
    else

    echo "¿Qué nombre desea para el usuario?"
read nombreUser
useradd -m -G wheel -s /bin/bash $nombreUser

    ;;
    4)
#Permitir que el usuario tenga SUDO
clear
echo "Ahora descomente la siguiente línea, de tal manera que quede así: "
echo "%wheel ALL=(ALL) ALL"
echo "Se encuentra casi al último del archivo"
echo "Presione Enter..."
read
EDITOR=nano visudo
    ;;
    5)
#Ahora se instala el Bootloader
clear
echo "Ahora se procederá a activar OS PROBER para que se detecte otros sistemas operativos"
sleep 1

echo "Por favor, cambie la linea o agregue: GRUB_DISABLE_OS_PROBER=false"
echo "Pulse ENTER para continuar"
read
nano /etc/default/grub
    ;;
    6)
    echo
    echo "¿Está seguro?, no hay paso atras, y se continuará con la selección de contraseñas"
    echo "Su estilo de partición es $disco"
    echo "El nombre de su máquina es $nombreMaquina"
    echo "El nombre de su usuario es $nombreUser"
    echo "Pulse S o N"
    read son
    if [ "$son" = "s" ] || [ "$son" = "S" ]; then
    break
    fi

    ;;
    esac
done

clear

while true; do
#Contraseña ROOT
echo "Contraseña para el usuario root"
passwd


echo "¿Desea una contraseña diferente para root? [S/N]"
read paraRoot
if [ "$paraRoot" = "N" ] || [ "$paraRoot" = "n" ]; then
break
fi
sleep 1
clear
done

while true; do
#Contraseña de Usuario
echo "Ahora la contraseña para $nombreUser"
passwd $nombreUser
sleep 1


echo "¿Desea una contraseña diferente para $nombreUser? [S/N]"
read paraRoot
if [ "$paraRoot" = "N" ] || [ "$paraRoot" = "n" ]; then
break
fi
clear
done
#Fin del bucle principal

clear
echo "$nombreMaquina" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $nombreMaquina.localdomain $nombreMaquina
EOF
echo "Instalando el Bootloader GRUB"
$discoMBRorGPT
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
echo "Instalación terminada :D"
sleep 2

exit
