#!/bin/bash

#El script está hecho para instalar los paquetes que YO necesito, por lo que tiene pocas instrucciones

# VARIABLES
logeadoComo=$(whoami)


multimedia="alsa-utils alsa-plugins alsa-firmware alsa-oss pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav mpv vlc vulkan-tools elisa intel-media-driver  libva-intel-driver  vulkan-intel libvdpau-va-gl"
appsPersonales="kdenlive musescore audacity gimp inkscape digikam darktable blender krita libreoffice-fresh onlyoffice-bin obs-studio"
coreApps="ntfs-3g dosfstools btrfs-progs zip unzip unrar p7zip vulkan-icd-loader gvfs gvfs-mtp lib32-vulkan-icd-loader epson-inkjet-printer-escpr brave-bin pamac yay cups cups-pdf system-config-printer avahi nss-mdns sane simple-scan gamemode innoextract lib32-gamemode lib32-gnutls lib32-mesa-libgl lib32-vkd3d python-pefile vkd3d harvid new-session-manager xjadeo "
fuentesFonts="ttf-droid ttf-freefont ttf-dejavu ttf-liberation ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts"
aInstalar="$multimedia $appsPersonales $coreApps $fuentesFonts"

# Entornos de Escritorio
plasma="plasma sddm konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect"
xfce="xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-whiskermenu-plugin"
lxqt="lxqt breeze-icons sddm sddm-kcm"
gnome="gnome gdm gnome-tweaks gnome-shell-extensions"
cinnamon="cinnamon lightdm lightdm-slick-greeter"
mate="mate mate-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
budgie="budgie-desktop gnome gdm"
# Window Manager
i3="i3-wm i3status i3lock dmenu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
openbox="openbox obconf-qt tint2 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
awesome="awesome rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
bspwm="bspwm sxhkd rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
hyprland="hyprland waybar swaybg swaylock wofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"


paquetesTotales="alsa-utils alsa-plugins alsa-firmware alsa-oss pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav mpv vlc vulkan-tools elisa intel-media-driver  libva-intel-driver  vulkan-intel libvdpau-va-gl kdenlive musescore audacity gimp inkscape digikam darktable blender krita libreoffice-fresh onlyoffice-bin obs-studio ntfs-3g dosfstools btrfs-progs zip unzip unrar p7zip vulkan-icd-loader gvfs gvfs-mtp lib32-vulkan-icd-loader epson-inkjet-printer-escpr brave-bin pamac yay cups cups-pdf system-config-printer avahi nss-mdns sane simple-scan ttf-droid ttf-freefont ttf-dejavu ttf-liberation ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts plasma sddm konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-whiskermenu-plugin lxqt breeze-icons sddm sddm-kcm gnome gdm gnome-tweaks gnome-shell-extensions cinnamon lightdm lightdm-slick-greeter mate mate-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings budgie-desktop gnome gdm i3-wm i3status i3lock dmenu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings openbox obconf-qt tint2 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings awesome rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings bspwm sxhkd rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings hyprland waybar swaybg swaylock wofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"


#Funciones
instaladorBRM(){
echo "Antes de instalar, se solicita conexión a internet estable, y se reiniciará la PC para empezar sin problemas..."
echo
sleep 1
echo "Presione enter para continuar..."
read
clear
echo "Instalando los paquetes de Broadcom para mi BCM43224 y configurando"
pacman -S --needed --noconfirm $broadcomPaquetes
sleep .4
modprobe wl
echo "Poniendo en Lista Negra algunos drivers para evitar problemas"
echo "blacklist b43" | sudo tee /etc/modprobe.d/blacklist-b43.conf
echo "blacklist ssb" | sudo tee /etc/modprobe.d/blacklist-ssb.conf
sleep .5
echo "Activando Network Manager"
systemctl enable --now NetworkManager
sleep 1
echo "Proceso Finalizado..."
sleep .3
echo
echo "Ahora se reiniciará para cargar correctamente todo."
echo "Por favor, ejecutar este script nuevamente despues de haber reiniciado"
echo "Presione enter para continuar"
read
reboot now
exit
}






# SCRIPT
clear
echo "Actualmente estas logeado como: $logeadoComo"

if [ "$logeadoComo" != "root" ]; then
    sleep 2
    echo "Necesitamos de los permisos de superusuario para continuar"
    sudo "$0" "$@"
    exit
fi



clear
echo "Este scrript instalará todos los paquetes necesarios para tener una experiencia mucho más OUT-THE-BOX en Arch Linux"
sleep 2
echo "Pulse Enter para continuar"
read
clear

echo "¿Desea instalar los drivers Broadom para su PC? [S/N]"
read broad
if [ "$broad" = "S" ] || [ "$broad" = "s" ]; then
echo "Ejecutando el instalador de Drivers Broadcom"
pause 1
clear
instaladorBRM
fi
clear
    echo "Añadiendo ChaoticAUR (y Multilib)"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo "#Multilib" >> /etc/pacman.conf
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo "#Chaotic AUR" >> /etc/pacman.conf
    echo "[chaotic-aur]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    echo
    echo "Ahora a instalar paquetes que yo necesito para el día a día"
clear


while true; do
clear
echo "Elige el DE o WM que prefieras:"
echo "1) XFCE"
echo "2) LXQt"
echo "3) KDE Plasma"
echo "4) GNOME"
echo "5) Cinnamon"
echo "6) MATE"
echo "7) Budgie"
echo "8) i3"
echo "9) Openbox"
echo "10) Awesome"
echo "11) bspwm"
echo "12) Hyprland"
read opcion
case $opcion in
        1) de=$xfce; break ;;
        2) de=$lxqt; break ;;
        3) de=$plasma; break ;;
        4) de=$gnome; break ;;
        5) de=$cinnamon; break ;;
        6) de=$mate; break ;;
        7) de=$budgie; break ;;
        8) de=$i3; break ;;
        9) de=$openbox; break ;;
        10) de=$awesome; break ;;
        11) de=$bspwm; break ;;
        12) de=$hyprland; break ;;
        *) echo "Opción inválida"; sleep 2 ;;
esac

done

aInstalar="$aInstalar $de"


echo "¿Desea una instalación Offline? [S/N]"
echo "Puede tardar mucho menos que la Online, pero necesita algo de tiempo para copiar algunos paquetes"
read offlineMode

if [ "$offlineMode" = "S" ] || [ "$offlineMode" = "s" ]; then
REPO_DIR="/root/temp"
mkdir -p "$REPO_DIR"
cp -r ./pkgs/* $REPO_DIR
cd "$REPO_DIR"

    echo "[localrepo]" | tee -a /etc/pacman.conf
    echo "SigLevel = Optional TrustAll" | tee -a /etc/pacman.conf
    echo "Server = file://$REPO_DIR" | tee -a /etc/pacman.conf
    pacman -Syy --needed --noconfirm $aInstalar
    else
    pacman -Syyu --needed --noconfirm $aInstalar

fi




case $opcion in
  1|5|6|8|9|10|11|12) dm="lightdm" ;; # XFCE, Cinnamon, MATE, i3, Openbox, Awesome, bspwm, Hyprland
  2|3) dm="sddm" ;;                     # LXQt, Plasma
  4|7) dm="gdm" ;;                      # GNOME, Budgie
esac

    systemctl enable $dm.service
    systemctl enable cups
    systemctl enable bluetooth
    systemctl enable avahi-daemon.service

echo "Por favor. Borre la carpeta $REPO_DIR y modifique /etc/pacman.conf para quitar este repositorio temporal"
