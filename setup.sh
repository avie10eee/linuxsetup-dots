#!/usr/bin/bash

echo "##############################"
echo "# Welcome to PigOS installer #"
echo "##############################"


echo "# Configuring DNF for speed #"
echo " " | sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "max_parallel_downloads = 5 = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'

echo "# Upgrading your system #"
echo " " | sudo dnf upgrade
sleep 10

echo "# Installing selected PKGs #"
echo " " | sudo dnf install tldr cmake curl tree sl latte-dock fontawesome-fonts fontawesome-fonts-web polybar virt-manager qemu bash coreutils edk2-tools grep jq lsb procps python3 genisoimage usbutils util-linux sed spice-gtk-tools swtpm wget xdg-user-dirs xrandr unzip brasero neofetch alacritty micro tmux wl-clipboard kvantum bat flameshot opendoas

sleep 60

echo "# Starting NIX Package Manager installation #"
echo " " | sudo mkdir /nix
echo " " | chown $USER /nix

#installing nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

sleep 60

#linking nix apps to usr/share/applications
echo " " | sudo ln -s /nix/var/nix/profiles/per-user/$USER/profile/share/applications /usr/share/applications


echo "# Enabling RPM-Fusion repositories #"
#enabling rpm-fusion
echo " " | sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo " " | sudo dnf groupupdate core
#multimedia and intel codecs
echo " " | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
echo " " | sudo dnf groupupdate sound-and-video
echo " " | sudo dnf install intel-media-driver
echo " " | sudo dnf install ocs-url-3.1.0-1.fc20.x86_64.rpm

sleep 60

# Kde stuff
#curl stuff: 1=moe-dark-look-and-feel-global-theme 2=colloid-full-icon-theme
#curl https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1645543295/Moe-Dark.tar.gz?response-content-disposition=attachment%3B%2520Moe-Dark.tar.gz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20230302%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230302T034956Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=e01c061458c6e8bc5415cf37ed72207212622c18bc12b57aee9d075c44718b25
#curl https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1639061356/Colloid-teal.tar.xz?response-content-disposition=attachment%3B%2520Colloid-teal.tar.xz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20230302%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230302T035348Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=8628932a39e5b7d2893f497ebd322c1e54475d78e13ccf56172990ec84f748eb

#unzip curl stuff
#tar -xf Moe-Dark.tar.gz
#tar -xf Colloid-teal.tar.xz


#crontab stuff(not sure if it works)
echo "# Updating Cron jobs to update on reboot #"
echo "@reboot echo " " | sudo dnf upgrade
@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
@reboot nix-collect-garbage
@reboot echo " " | sudo dnf autoremove" | crontab -e

sleep 60

#uncomment if using kde
#mkdir ~/.config/polybar

#git cloning
#git clone https://github.com/adi1090x/polybar-themes "~/.config/polybar"
git clone https://github.com/catppuccin/alacritty.git "~/.config/alacritty"


#echo "1" | sh ~/.config/polybar/polybar-themes/setup.sh

echo "# Adding Nerd fonts to ~/.fonts/truetype #"
mkdir ~/.fonts && mkdir ~/.fonts/truetype
mv ~/setup/fonts/* ~/.fonts/truetype


mv ~/setup/neofetch/config.conf ~/.config/neofetch

echo "# Adding micro configuration #"
echo "{
    "autosave": 1,
    "hlsearch": true
}" > ~/.config/micro/settings.json

#after-reboot
echo "nix-env -iA nixpkgs.quickemu nixpkgs.pywal nixpkgs.tty-clock" > ~/after-reboot.txt

#tmux config
echo "set -g mouse on" >> ~/.tmux.conf


echo "# Installing ZSH for Humans #"
#install zsh4humans (PUT AT THE END)
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi

echo "neofetch" >> .zshrc
echo "alias sudo="doas"" >> .zshrc

echo "# Please Reboot!! #"


