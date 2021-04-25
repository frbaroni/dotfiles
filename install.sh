#!/bin/bash

USER_NAME=${USER}
USER_GROUP=${GID}
DISTRO_HOME=$(realpath ~)
DOTFILES=$(realpath $(dirname "$0"))
DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

SHARED_PACKAGES='flatpak git neovim xclip tmux firefox thunderbird zsh variety'
ARCH_PACKAGES='virt-manager qemu cronie nodejs borg'
DEBIAN_PACKAGES='python3-pip'
CARGO_PACKAGES='alacritty ripgrep exa bat'
FLATPAK_PACKAGES='com.calibre_ebook.calibre com.discordapp.Discord org.zealdocs.Zeal org.godotengine.Godot org.keepassxc.KeePassXC me.kozec.syncthingtk org.speedcrunch.SpeedCrunch com.jgraph.drawio.desktop org.flameshot.Flameshot'

if [[ ${DISTRO} == "Ubuntu" ]]; then
	sudo apt update
	sudo apt upgrade
	sudo apt install -y ${SHARED_PACKAGES} ${DEBIAN_PACKAGES}
fi

sudo pip3 install pynvim

for dir in "${DISTRO_HOME}/.vim_undo ${DISTRO_HOME}/.vim_backup ${DISTRO_HOME}/.vim_swap";
do
	if [[ ! -d ${dir} ]]; then
		echo "Creating ${DIR}"
		mkdir -p ${dir}
	fi
done

function ensure_symlink() {
	echo Symlinking $1 to $2
	rm -rf ${2}
	ln -s ${1} ${2}
        chown ${USER_NAME}:${USER_GROUP} ${2}
}

if [[ -d /frb ]]; then
        echo "Creating bord cronjob"
        crontab -l | grep -v borgbackup | { cat; echo "@reboot /frb/Sync/borgbackup/cron.sh"; } | crontab -
        ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc
        echo "Creating links on /frb"
        ensure_symlink /frb/VMNetwork ${DISTRO_HOME}/VMNetwork
        ensure_symlink /frb/Fotos ${DISTRO_HOME}/Fotos
        ensure_symlink /frb/Sync ${DISTRO_HOME}/Sync
        ensure_symlink /frb/p ${DISTRO_HOME}/p
        ensure_symlink /frb/thunderbird ${DISTRO_HOME}/.thunderbird
fi
echo "Creating links from ${DOTFILES}"
ensure_symlink ${DOTFILES}/ssh ${DISTRO_HOME}/.ssh
ensure_symlink ${DOTFILES}/awesome ${DISTRO_HOME}/.config/awesome
ensure_symlink ${DOTFILES}/vim ${DISTRO_HOME}/.config/nvim
ensure_symlink ${DOTFILES}/vim ${DISTRO_HOME}/.vim
ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub ${FLATPAK_PACKAGES}

git clone https://github.com/robbyrussell/oh-my-zsh ${DISTRO_HOME}/.oh-my-zsh
ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc
