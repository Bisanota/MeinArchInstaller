#!/bin/bash

# Script de instalación post-Arch, ajustado para experiencia out-the-box

# VARIABLES
logeadoComo=$(whoami)

multimedia="alsa-utils alsa-plugins alsa-firmware alsa-oss pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav mpv vlc vulkan-tools elisa intel-media-driver libva-intel-driver vulkan-intel libvdpau-va-gl"
appsPersonales="kdenlive musescore audacity gimp inkscape digikam darktable blender krita libreoffice-fresh onlyoffice-bin obs-studio"
coreApps="ntfs-3g dosfstools btrfs-progs zip unzip unrar p7zip vulkan-icd-loader gvfs gvfs-mtp lib32-vulkan-icd-loader epson-inkjet-printer-escpr brave-bin pamac yay cups cups-pdf system-config-printer avahi nss-mdns sane simple-scan gamemode innoextract lib32-gamemode lib32-gnutls lib32-mesa-libgl lib32-vkd3d python-pefile vkd3d harvid new-session-manager xjadeo"
fuentesFonts="ttf-droid ttf-freefont ttf-dejavu ttf-liberation ttf-opensans noto-fonts noto-fonts-cjk noto-fonts-emoji adobe-source-han-sans-otc-fonts"
aInstalar="$multimedia $appsPersonales $coreApps $fuentesFonts"

# Entornos de Escritorio / WM
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

# FUNCIONES
instaladorBRM(){
    echo "Antes de instalar, se solicita conexión a internet estable, y se reiniciará la PC..."
    echo "Presione Enter para continuar..."
    read
    clear
    echo "Instalando paquetes Broadcom..."
    pacman -S --needed --noconfirm $broadcomPaquetes
    sleep .4
    modprobe wl
    echo "Blacklisteando drivers conflictivos..."
    echo "blacklist b43" | tee /etc/modprobe.d/blacklist-b43.conf
    echo "blacklist ssb" | tee /etc/modprobe.d/blacklist-ssb.conf
    sleep .5
    echo "Activando Network Manager"
    systemctl enable --now NetworkManager
    sleep 1
    echo "Proceso Finalizado. Reiniciando..."
    read -p "Presione Enter para continuar..."
    reboot now
    exit
}

add_repo(){
    local repo_name=$1
    local content=$2
    if ! grep -q "^\[$repo_name\]" /etc/pacman.conf; then
        echo -e "\n# $repo_name\n$content" >> /etc/pacman.conf
    fi
}

# SCRIPT
clear
echo "Actualmente estas logeado como: $logeadoComo"

if [ "$logeadoComo" != "root" ]; then
    echo "Necesitamos permisos de superusuario para continuar"
    sudo "$0" "$@"
    exit
fi

clear
echo "Este script instalará paquetes para una experiencia OUT-THE-BOX en Arch Linux"
read -p "Pulse Enter para continuar..."

# Broadcom
echo "¿Desea instalar los drivers Broadcom para su PC? [S/N]"
read broad
if [[ "$broad" =~ ^[Ss]$ ]]; then
    instaladorBRM
fi

clear
echo "Añadiendo ChaoticAUR y Multilib..."
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -Sy --noconfirm chaotic-keyring chaotic-mirrorlist

add_repo "multilib" "[multilib]\nInclude = /etc/pacman.d/mirrorlist"
add_repo "chaotic-aur" "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist"

# Selección de entorno
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

# Instalación Offline u Online
echo "¿Desea una instalación Offline? [S/N]"
read offlineMode

if [[ "$offlineMode" =~ ^[Ss]$ ]]; then
    REPO_DIR="/root/temp"
    mkdir -p "$REPO_DIR"
    cp -r ./pkgs/* "$REPO_DIR"
    cd "$REPO_DIR"

    add_repo "localrepo" "[localrepo]\nSigLevel = Optional TrustAll\nServer = file://$REPO_DIR"

    pacman -Syy --needed --noconfirm $aInstalar

    # Limpieza
    sed -i '/\[localrepo\]/,/Server/d' /etc/pacman.conf
    rm -rf "$REPO_DIR"
else
    pacman -Syyu --needed --noconfirm $aInstalar
fi

# Servicios
systemctl enable $dm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service

echo "Instalación completada 🎉"
