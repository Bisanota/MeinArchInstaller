#!/bin/bash

# Script de instalación post-Arch

logeadoComo=$(whoami)

multimedia="alsa-utils alsa-plugins alsa-firmware alsa-oss pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav mpv vlc vulkan-tools elisa intel-media-driver libva-intel-driver vulkan-intel libvdpau-va-gl mesa-utils"
appsPersonales="kdenlive musescore audacity gimp inkscape digikam darktable blender krita libreoffice-fresh obs-studio"
coreApps="ntfs-3g dosfstools btrfs-progs zip unzip unrar p7zip vulkan-icd-loader gvfs gvfs-mtp lib32-vulkan-icd-loader cups cups-pdf system-config-printer avahi nss-mdns sane simple-scan gamemode innoextract lib32-gamemode lib32-gnutls lib32-mesa-libgl lib32-vkd3d python-pefile vkd3d harvid new-session-manager xjadeo ufw"
fuentesFonts="ttf-droid ttf-freefont ttf-dejavu ttf-liberation ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts noto-fonts-extra inter-font ttf-fira-sans ttf-ms-fonts apple-fonts ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-ubuntu-nerd ttf-ubuntu-mono-nerd"
chaoticAURPkgs="epson-inkjet-printer-escpr brave-bin pamac yay onlyoffice-bin"
aInstalar="$multimedia $coreApps $fuentesFonts $chaoticAURPkgs"
#otros="netcat"

# DE / WM
plasma="plasma sddm konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect"
xfce="xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-whiskermenu-plugin blueman network-manager-applet"
lxqt="lxqt breeze-icons sddm sddm-kcm"
gnome="gnome gdm gnome-tweaks gnome-shell-extensions gnome-extra polkit-gnome extension-manager"
cinnamon="cinnamon lightdm lightdm-slick-greeter"
mate="mate mate-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
budgie="budgie-desktop gnome gdm"
i3="i3-wm i3status i3lock dmenu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
openbox="openbox obconf-qt tint2 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings rofi picom nitrogen blueman"
awesome="awesome rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
bspwm="bspwm sxhkd rofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
hyprland="hyprland waybar swaybg swaylock wofi lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"

broadcomPaquetes="dkms linux-headers broadcom-wl-dkms"

instaladorBRM(){
    echo "Instalando drivers Broadcom..."
    pacman -S --needed --noconfirm $broadcomPaquetes
    modprobe wl
    echo "blacklist b43" | tee /etc/modprobe.d/blacklist-b43.conf
    echo "blacklist ssb" | tee /etc/modprobe.d/blacklist-ssb.conf
    systemctl enable --now NetworkManager
    echo "Proceso finalizado. Reiniciando..."
    read -p "Presione Enter para continuar..."
    reboot now
    exit
}

# Comprobación root
if [ "$logeadoComo" != "root" ]; then
    sudo "$0" "$@"
    exit
fi

echo "Este script instalará paquetes para Arch Linux."
read -p "Presione Enter para continuar..."

# Broadcom
echo "¿Desea instalar los drivers Broadcom? [S/N]"
read broad
if [[ "$broad" =~ ^[Ss]$ ]]; then
    instaladorBRM
fi

# Selección DE / WM
while true; do
    echo "Elige el DE o WM: (PD: De momento solo funciona correctamente KDE Plasma, por favor, tener eso en cuenta, los demas DE y WM no han sido probados del todo)"
    echo "1) XFCE 2) LXQt 3) Plasma 4) GNOME 5) Cinnamon 6) MATE 7) Budgie 8) i3 9) Openbox 10) Awesome 11) bspwm 12) Hyprland"
    read opcion
    case $opcion in
        1) de=$xfce; dm="lightdm"; break ;;
        2) de=$lxqt; dm="sddm"; break ;;
        3) de=$plasma; dm="sddm"; break ;;
        4) de=$gnome; dm="gdm"; break ;;
        5) de=$cinnamon; dm="lightdm"; break ;;
        6) de=$mate; dm="lightdm"; break ;;
        7) de=$budgie; dm="gdm"; break ;;
        8) de=$i3; dm="lightdm"; break ;;
        9) de=$openbox; dm="lightdm"; break ;;
        10) de=$awesome; dm="lightdm"; break ;;
        11) de=$bspwm; dm="lightdm"; break ;;
        12) de=$hyprland; dm="lightdm"; break ;;
        *) echo "Opción inválida"; sleep 2 ;;
    esac
done

aInstalar="$aInstalar $de"

clear
echo "¿Quieres las apps personales?"
read sinooque
if [[ "$sinooque" =~ ^[Ss]$ ]]; then
    aInstalar="$aInstalar $appsPersonales"
fi

# Instalación Online
instalacionOnline="pacman -Syyu --needed --noconfirm $aInstalar"
intentos=0
intentosMax=5
haFuncionado=0

echo "Empezando la instalación"
while [ $intentos -le $intentosMax ] ; do

    $instalacionOnline && break
    echo "Ha fallado :c"
    intentos=$((intentos + 1))
    haFuncionado=1
done
if [ $haFuncionado == 0 ]; then
# Servicios
systemctl enable $dm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service

# SWAPFILE ----> REMOVIDO/COMENTADO PORQUE EL ARCHIVO AUTOSWAPFILE... YA HACE ESTO
# sudo fallocate -l 4G /swapfile
# sudo chmod 600 /swapfile
# sudo swapon /swapfile
# sudo mkswap /swapfile
# echo "/swapfile none swap defaults 0 0" >> /etc/fstab

echo "Instalación completada 🎉"

    else
    echo "La instalación ha fallado :("

fi
