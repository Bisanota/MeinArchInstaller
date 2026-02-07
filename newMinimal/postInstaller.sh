#!/bin/bash

# Variables

printer="cups cups-pdf avahi nss-mdns"
chaoticAUR="helium-browser-bin epson-inkjet-printer-escpr" # or brave-bin for Browsers. Helium by default. Epson Printer Drivers Installed
scanner="sane"
optional="htop fastfetch ufw gamemode lib32-gamemode"
fonts="ttf-dejavu noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-droid ttf-freefont ttf-liberation ttf-opensans ttf-roboto ttf-jetbrains-mono ttf-ms-fonts"
audio="pipewire pipewire-alsa pipewire-pulse pipewire-jack alsa-utils wireplumber"
video="mesa mesa-utils"
vulkan="vulkan-tools vulkan-icd-loader lib32-vulkan-icd-loader"
codecs="ffmpeg gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav"
reproductor="mpv"
filesystem="ntfs-3g dosfstools btrfs-progs zip unzip p7zip unrar exfatprogs fuse2"
services="avahi nss-mdns"
extras="plymouth"
guiServices="system-config-printer network-manager-applet simple-scan"

dm_sddm="sddm"
dm_gdm="gdm"
dm_lightdm="lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
dm_greetd="greetd"
plasma="$dm_sddm plasma konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect"
xfce="$dm_lightdm xfce4 xfce4-goodies xfce4-whiskermenu-plugin blueman"
gnome="$dm_gdm gnome gnome-tweaks gnome-shell-extensions polkit-gnome extension-manager"
gnomeExtra="gnome-extra"
i3="$dm_lightdm i3-wm i3status i3lock dmenu"
openbox="$dm_lightdm openbox obconf-qt tint2 rofi picom xdg-utils xdg-user-dirs dunst"
hyprland="$dm_greetd hyprland waybar swaybg swaylock wofi"

packages="$printer $chaoticAUR $scanner $optional"
packages1="$fonts $audio $video $vulkan $codecs $reproductor"
packages2="$filesystem $services $extras $guiServices"

# Functions

loadingFunction() {
echo -n "["
    bucleSleepNum=0
    bucleSleepMax=40
    while [ $bucleSleepNum -le $bucleSleepMax ]; do
    echo -n .
    sleep 0.04
    bucleSleepNum=$((bucleSleepNum + 1))
done
echo "]"
}

# Main
clear
echo "Loading"
loadingFunction
while true; do
    echo "Choose a DE or WM:"
    echo " 1) KDE Plasma"
    echo " 2) GNOME"
    echo " 3) XFCE"
    echo " 4) i3"
    echo " 5) Openbox"
    echo " 6) Hyprland"
    echo "Option: "
    read opcion
    case $opcion in
        1) de=$plasma; dm="sddm"; break ;;
        2) de=$gnome; dm="gdm"; break ;;
        3) de=$xfce; dm="lightdm"; break ;;
        4) de=$i3; dm="lightdm"; break ;;
        5) de=$openbox; dm="lightdm"; break ;;
        6) de=$hyprland; dm="greetd"; break ;;
        *) echo "Not valid option!!!"; sleep 2 ;;
    esac
done
clear
echo "Preparing"
loadingFunction
if [ "$opcion" == "2" ]; then
    echo -n "Do you like to install some GNOME native apps? [Y/N]: "
    read gnomeOption
    if [ "$gnomeOption" == "Y" || "$gnomeOption" == "y" ]; then
        gnome="$gnome $gnomeExtra"
    fi
fi

clear
echo "This part may take a lot of time"
sleep 2
loadingFunction
pacman -Sy --noconfirm --needed $packages
pacman -S --noconfirm --needed $packages1
pacman -S --noconfirm --needed $packages2
pacman -S --noconfirm --needed $de

clear
echo "Activating services."
loadingFunction
systemctl enable $dm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service

echo "Installation Complete :)"
loadingFunction
