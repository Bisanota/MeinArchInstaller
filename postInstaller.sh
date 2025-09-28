#!/bin/bash

# Script de instalación post-Arch

logeadoComo=$(whoami)

multimedia="alsa-utils alsa-plugins alsa-firmware alsa-oss pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav mpv vlc vulkan-tools elisa intel-media-driver libva-intel-driver vulkan-intel libvdpau-va-gl"
appsPersonales="kdenlive musescore audacity gimp inkscape digikam darktable blender krita libreoffice-fresh onlyoffice-bin obs-studio"
coreApps="ntfs-3g dosfstools btrfs-progs zip unzip unrar p7zip vulkan-icd-loader gvfs gvfs-mtp lib32-vulkan-icd-loader epson-inkjet-printer-escpr brave-bin pamac yay cups cups-pdf system-config-printer avahi nss-mdns sane simple-scan gamemode innoextract lib32-gamemode lib32-gnutls lib32-mesa-libgl lib32-vkd3d python-pefile vkd3d harvid new-session-manager xjadeo"
fuentesFonts="ttf-droid ttf-freefont ttf-dejavu ttf-liberation ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts"
aInstalar="$multimedia $appsPersonales $coreApps $fuentesFonts"

# DE / WM
plasma="plasma sddm konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect"
xfce="xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4-whiskermenu-plugin"
lxqt="lxqt breeze-icons sddm sddm-kcm"
gnome="gnome gdm gnome-tweaks gnome-shell-extensions"
cinnamon="cinnamon lightdm lightdm-slick-greeter"
mate="mate mate-extra lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
budgie="budgie-desktop gnome gdm"
i3="i3-wm i3status i3lock dmenu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
openbox="openbox obconf-qt tint2 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
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

# Chaotic AUR y multilib
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -S --noconfirm chaotic-keyring chaotic-mirrorlist

echo -e "\n#Multilib\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo -e "\n#Chaotic AUR\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Selección DE / WM
while true; do
    echo "Elige el DE o WM:"
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

# Instalación Online
pacman -Syyu --needed --noconfirm $aInstalar

# Servicios
systemctl enable $dm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service

echo "Instalación completada 🎉"
