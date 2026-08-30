#!/bin/bash
# "things to do!" script for a fresh fedora workstation installation

# check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "please run this script with sudo"
    exit 1
fi

# funtion to echo colored text
color_echo() {
    local color="$1"
    local text="$2"
    case "$color" in
        "red")     echo -e "\033[0;31m$text\033[0m" ;;
        "green")   echo -e "\033[0;32m$text\033[0m" ;;
        "yellow")  echo -e "\033[1;33m$text\033[0m" ;;
        "blue")    echo -e "\033[0;34m$text\033[0m" ;;
        *)         echo "$text" ;;
    esac
}

# set variables
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(getent passwd "$ACTUAL_USER" | cut -d: -f6)
log_file="/var/log/fedora_things_to_do.log"
initial_dir=$(pwd)
# Define a variável DBUS para o gsettings funcionar via sudo
DBUS_PATH="unix:path=/run/user/$(id -u $ACTUAL_USER)/bus"

# function to generate timestamps
get_timestamp() {
    date +"%y-%m-%d %h:%m:%s"
}

# function to log messages
log_message() {
    local message="$1"
    echo "$(get_timestamp) - $message" | tee -a "$log_file"
}

# function to handle errors
handle_error() {
    local exit_code=$?
    local message="$1"
    if [ $exit_code -ne 0 ]; then
        color_echo "red" "error: $message"
        exit $exit_code
    fi
}

# function to prompt for reboot
prompt_reboot() {
    sudo -u $ACTUAL_USER bash -c 'read -p "it is time to reboot the machine. would you like to do it now? (y/n): " choice; [[ $choice == [yy] ]]'
    if [ $? -eq 0 ]; then
        color_echo "green" "rebooting..."
        reboot
    else
        color_echo "red" "reboot canceled."
    fi
}

# function to backup configuration files
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
        handle_error "failed to backup $file"
        color_echo "green" "backed up $file"
    fi
}

echo "";
echo "╔═════════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                             ║";
echo "║   ░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░░░█░█░█▀█░█▀▄░█░█░█▀▀░▀█▀░█▀█░▀█▀░▀█▀░█▀█░█▀█░   ║";
echo "║   ░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░░░█▄█░█░█░█▀▄░█▀▄░▀▀█░░█░░█▀█░░█░░░█░░█░█░█░█░   ║";
echo "║   ░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░   ║";
echo "║   ░░░░░░░░░░░░▀█▀░█░█░▀█▀░█▀█░█▀▀░█▀▀░░░▀█▀░█▀█░░░█▀▄░█▀█░█░░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░█░░█▀█░░█░░█░█░█░█░▀▀█░░░░█░░█░█░░░█░█░█░█░▀░░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░░░▀░░▀▀▀░░░▀▀░░▀▀▀░▀░░░░░░░░░░░░░░   ║";
echo "║                                                                             ║";
echo "╚═════════════════════════════════════════════════════════════════════════════╝";
echo "";
echo "this script automates \"things to do!\" steps after a fresh fedora workstation installation"
echo "ver. 25.08 / 100 stars edition"
echo ""
echo "don't run this script if you didn't build it yourself or don't know what it does."
echo ""
read -p "press enter to continue or ctrl+c to cancel..."

# system upgrade
color_echo "blue" "performing system upgrade... this may take a while..."
dnf upgrade -y

# system configuration
# set the system hostname to uniquely identify the machine on the network
color_echo "yellow" "setting hostname..."
hostnamectl set-hostname fed342

# optimize dnf package manager for faster downloads and efficient updates
color_echo "yellow" "configuring dnf package manager..."
backup_file "/etc/dnf/dnf.conf"
dnf -y install dnf-plugins-core
# max parallel downloads
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf > /dev/null
# select fastest mirror
echo "fastestmirror=true" | tee -a /etc/dnf/dnf.conf > /dev/null
# default yes
echo "defaultyes=true" | tee -a /etc/dnf/dnf.conf > /dev/null

# replace fedora flatpak repo with flathub for better package management and apps stability
color_echo "yellow" "replacing fedora flatpak repo with flathub..."
dnf install -y flatpak
flatpak remote-delete fedora --force 2>/dev/null || true
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak repair
flatpak update

# install and enable ssh server for secure remote access and file transfers
color_echo "yellow" "installing and enabling ssh..."
dnf install -y openssh-server
systemctl enable --now sshd

# check and apply firmware updates to improve hardware compatibility and performance
color_echo "yellow" "checking for firmware updates..."
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update -y

# enable rpm fusion repositories to access additional software packages and codecs
color_echo "yellow" "enabling rpm fusion repositories..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf update @core -y

# install multimedia codecs to enhance multimedia capabilities
color_echo "yellow" "installing multimedia codecs..."
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf update -y @multimedia --setopt="install_weak_deps=false" --exclude=packagekit-gstreamer-plugin

# install hardware accelerated codecs for intel integrated gpus
color_echo "yellow" "installing intel hardware accelerated codecs..."
dnf -y install intel-media-driver

# install virtualization tools to enable virtual machines and containerization
color_echo "yellow" "installing virtualization tools..."
dnf install -y @virtualization

# configure power settings to prevent system sleep and hibernation
color_echo "yellow" "configuring power settings..."
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.desktop.session idle-delay 0
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
sudo -u $ACTUAL_USER DBUS_SESSION_BUS_ADDRESS="$DBUS_PATH" gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'suspend'

# app installation
color_echo "yellow" "installing essential applications..."
dnf install -y \
  xz tar htop inxi unzip unrar git wget curl \
  gnome-tweaks \
  gnome-shell-extension-pop-shell \
  xprop \
  dnf-plugins-core \
  zsh \
  fastfetch \
  vlc \
  file-roller \
  dconf-editor \
  seahorse \
  gnome-disk-utility \
  gparted \
  shotcut \
  alsa-tools

color_echo "yellow" "configuring keyd..."
dnf copr enable -y alternateved/keyd
dnf install -y keyd
mkdir -p /etc/keyd
if [ -f "$ACTUAL_HOME/.config/default.conf" ]; then
  cp "$ACTUAL_HOME/.config/default.conf" /etc/keyd/default.conf
fi
systemctl enable --now keyd

color_echo "yellow" "installing mise..."
sudo -u $ACTUAL_USER mkdir -p "$ACTUAL_HOME/.local/bin" "$ACTUAL_HOME/.local/share/applications"
sudo -u "$ACTUAL_USER" bash -c 'curl -fsSL https://mise.run | sh'

color_echo "yellow" "installing essential applications via mise..."
sudo -u "$ACTUAL_USER" "$ACTUAL_HOME/.local/bin/mise" install -y

color_echo "green" "essential applications installed successfully."

# install terminal application
color_echo "yellow" "installing kitty..."
sudo -u "$ACTUAL_USER" bash -c 'curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

# Create symbolic links and desktop files with correct permissions
sudo -u "$ACTUAL_USER" ln -sf "$ACTUAL_HOME/.local/kitty.app/bin/kitty" "$ACTUAL_HOME/.local/kitty.app/bin/kitten" "$ACTUAL_HOME/.local/bin/"
sudo -u "$ACTUAL_USER" cp "$ACTUAL_HOME/.local/kitty.app/share/applications/kitty.desktop" "$ACTUAL_HOME/.local/share/applications/"
sudo -u "$ACTUAL_USER" cp "$ACTUAL_HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$ACTUAL_HOME/.local/share/applications/"

# update the paths to the kitty and its icon in the kitty desktop file(s)
sudo -u "$ACTUAL_USER" sed -i "s|icon=kitty|icon=$ACTUAL_HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" "$ACTUAL_HOME/.local/share/applications/kitty"*.desktop
sudo -u "$ACTUAL_USER" sed -i "s|exec=kitty|exec=$ACTUAL_HOME/.local/kitty.app/bin/kitty|g" "$ACTUAL_HOME/.local/share/applications/kitty"*.desktop

sudo -u "$ACTUAL_USER" bash -c "mkdir -p $ACTUAL_HOME/.config && echo 'kitty.desktop' > $ACTUAL_HOME/.config/xdg-terminals.list"
color_echo "green" "kitty installed successfully."

# install coding and devops applications
color_echo "yellow" "installing docker..."
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine --noautoremove
dnf -y install dnf-plugins-core
if command -v dnf4 &>/dev/null; then
  dnf4 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
else
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
fi
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
systemctl enable --now containerd
groupadd docker 2>/dev/null || true
usermod -aG docker $ACTUAL_USER
rm -rf "$ACTUAL_HOME/.docker"
color_echo "green" "docker installed successfully."

# note: docker group changes will take effect after logging out and back in
color_echo "yellow" "installing zsh and oh my zsh..."
dnf install -y zsh
sudo -u $ACTUAL_USER bash -c "RUNZSH=no \$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) \"\" --unattended"
chsh -s /bin/zsh $ACTUAL_USER

sudo -u $ACTUAL_USER bash -c '
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
'
color_echo "green" "zsh and oh my zsh installed successfully."

# flatpak desktop applications
color_echo "yellow" "installing flatpak gui applications..."
flatpak install -y flathub \
  md.obsidian.Obsidian \
  com.bitwarden.desktop \
  org.videolan.VLC \
  com.spotify.Client \
  org.gimp.GIMP \
  com.obsproject.Studio \
  io.missioncenter.MissionCenter \
  com.github.tchx84.Flatseal \
  com.mattjakeman.ExtensionManager \
  it.mijorus.gearlever \
  com.brave.Browser \
  io.github.vikdevelop.SaveDesktop \
  com.github.wwmm.easyeffects \
  com.calibre_ebook.calibre \
  io.github.herve4m.Length
  
# customization

# create symbolic links for custom scripts
sudo -u $ACTUAL_USER mkdir -p "$ACTUAL_HOME/.local/bin"
sudo -u $ACTUAL_USER ln -sf "$ACTUAL_HOME/Projects/bash_scripts/utils/iacp" "$ACTUAL_HOME/.local/bin/iacp"
sudo -u $ACTUAL_USER ln -sf "$ACTUAL_HOME/Projects/bash_scripts/utils/iacom" "$ACTUAL_HOME/.local/bin/iacom"
sudo -u $ACTUAL_USER ln -sf "$ACTUAL_HOME/Projects/bash_scripts/utils/copy" "$ACTUAL_HOME/.local/bin/copy"

# configure audio settings for dell laptops with headset mic
mkdir -p /etc/modprobe.d
echo "options snd-hda-intel model=dell-headset-mic" | tee -a /etc/modprobe.d/alsa-base.conf > /dev/null

# transform the gnome-ome.sd.tar.xz archive into a zip file

color_echo "yellow" "transforming gnome-ome.sd.tar.xz into gnome-ome.sd.zip..."
xz -dk $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd.tar.xz
tar -xf $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd.tar -C $ACTUAL_HOME/Downloads/SaveDesktop/archives/
zip -rq $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd.zip $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd
rm -rf $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd
rm -f $ACTUAL_HOME/Downloads/SaveDesktop/archives/gnome-ome.sd.tar
color_echo "green" "gnome-ome.sd.zip created successfully."

echo "created with ❤️ for open source"

# before finishing, ensure we're in a safe directory
cd /tmp || cd $ACTUAL_HOME || cd /

# finish
echo "";
echo "╔═════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                         ║";
echo "║   ░█░█░█▀▀░█░░░█▀▀░█▀█░█▄█░█▀▀░░░▀█▀░█▀█░░░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░█░   ║";
echo "║   ░█▄█░█▀▀░█░░░█░░░█░█░█░█░█▀▀░░░░█░░█░█░░░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░▀░   ║";
echo "║   ░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░░░▀░░▀▀▀░░░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░▀░   ║";
echo "║                                                                         ║";
echo "╚═════════════════════════════════════════════════════════════════════════╝";
echo "";
color_echo "green" "all steps completed. enjoy!"

# prompt for reboot
prompt_reboot
