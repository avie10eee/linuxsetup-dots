#!/bin/bash


#vars
DIR={$HOME}/setup
NERDF=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
PS3='Would you like to install any's: '
options=("SpectrWM" "CWM" "Qtile" "Hyprland" "AwesomeWM" "Skip")


#functions
welcome () {
    echo "################################"
    echo "# this is post PigOS installer #"
    echo "################################"
}

micro_conf () {

    echo "# Adding micro configuration #"

    mkdir -p ${HOME}/.config/micro/colorschemes
    mv ${DIR}catppuccin-mocha.micro ${HOME}/.config/micro/colorschemes

    echo '{
        "autosave": 1,
        "hlsearch": true
        "colorscheme": "gruvbox"
    }' > ${HOME}/.config/micro/settings.json

    #plugins
    micro -plugin install detectindent manipulator filemanager quoter
}

tmux_conf () {
    #turning on mouse in tmux
    echo "set -g mouse on" >> ${HOME}/.tmux.conf
}

zsh_conf () {

    echo "Configuring zshrc"
    #p10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo "${HOME}/setup/.zshrc" >> .zshrc

    #adding zsh plugins
    sed -i 's/ZSH_THEME=""/ZSH_THEME="powerlevel10k/powerlevel10k/"' ${HOME}/.zshrc
    sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/' .zshrc

}

wallpaper () {

    mkdir .wallpapers
    cp "${DIR}/wallpapers" ".wallpapers"
    mv "${DIR}/setup/autobg.sh" ${HOME}
}

colorscript_conf () {

    read -p "Have you installed DT's colorscripts Y/N " colorsc
    if [ "$colorsc" = 'y' ]; then
        echo "# Configuring DT's colorscripts"
        sleep 2
        colorscript -b xmonad
        colorscript -b tiefighter2
        colorscript -b tiefighter1row
        colorscript -b tifighter1
        colorscript -b thebat2
        colorscript -b spectrum
        colorscript -b pukeskull
        colorscript -b mouseface2
        colorscript -b guns
        colorscript -b colorbars
        colorscript -b bloks
        colorscript -b blok
    fi
}

nerd_font () {
    read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
    case $fontinst in
        y|Y ) echo "# Adding Nerd fonts to ${HOME}/.fonts/truetype #"; 
        mkdir -p ${HOME}/.fonts/truetype; wget -q ${NERDF}; 
        unzip "${HOME}/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"; 
        fc-cache;;

        n|N ) echo "Aborted, skipping...";;
    esac
}

doas_conf () {
    echo "Configuring doas"
    echo "add the following to /etc/doas.conf" > doas.txt
    echo "permit persist keepenv ${USER} as root" >> doas.txt
}

wms_inst () {
    select opt in "${options[@]}"
    do
        case $opt in
            "SpectrWM")
                nix-env -iA nixpkgs.spectrwm
                ;;
            "CWM")
                nix-env -iA nixpkgs.cwm
                ;;
            "Qtile")
                nix-env -iA nixpkgs.qtile
                ;;
            "Hyprland")
                nix-env -iA nixpkgs.hyprland
                ;;
            "AwesomeWM")
            nix-env -iA nixpkgs.awesome
            "Skip")
                break
                ;;
            *) echo "invalid option";;
        esac
    done
}

picom () {
    read -p "Would you like to install Picom Y/N " jona
    if [ "$jona" = 'y' ]; then
        nix-env -iA mixpkgs.picom-jonaburg
}

gooodbye () {
    echo "Thank you for using the PigOS script"
    sleep 2
    echo "I would recommend rebooting"
    sleep 5
}

#running functions
welcome
sleep 2
micro_conf
sleep 2
tmux_conf
sleep 2
zsh_conf
sleep 2
wallpaper
sleep 2
colorscript_conf
sleep 2
nerd_font
sleep 2
doas_conf
sleep 2
wms_inst
sleep 2
picom
sleep 2
gooodbye