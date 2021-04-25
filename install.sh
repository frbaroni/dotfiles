#!/bin/bash

USER_NAME=${USER}
USER_GROUP=${GID}
DISTRO_HOME=$(realpath ~)
DOTFILES=$(realpath $(dirname "$0"))
DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

SHARED_PACKAGES='flatpak git neovim xclip tmux firefox thunderbird zsh variety cargo'
ARCH_PACKAGES='virt-manager qemu cronie nodejs borg'
DEBIAN_PACKAGES='python3-pip yarnpkg'
CARGO_PACKAGES='alacritty ripgrep exa bat'
FLATPAK_PACKAGES='com.calibre_ebook.calibre com.discordapp.Discord org.zealdocs.Zeal org.godotengine.Godot org.keepassxc.KeePassXC me.kozec.syncthingtk org.speedcrunch.SpeedCrunch com.jgraph.drawio.desktop org.flameshot.Flameshot'
CREATE_DIRS="${DISTRO_HOME}/.vim_undo ${DISTRO_HOME}/.vim_backup ${DISTRO_HOME}/.vim_swap"

function ensure_symlink() {
  echo Symlinking $1 to $2
  rm -rf ${2}
  ln -s ${1} ${2}
  chown ${USER_NAME}:${USER_GROUP} ${2}
}

if [ "$DISTRO" = "Ubuntu" ]; then
  echo "Updating Ubuntu"
  sudo apt update
  sudo apt upgrade -y
  echo "Installing Packages"
  sudo apt install -y ${SHARED_PACKAGES} ${DEBIAN_PACKAGES}
else
  echo "NOT UBUNTU"
fi

echo "Installing pynvim through pip3"
sudo pip3 install pynvim

echo "Installing Flathub and packages"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub ${FLATPAK_PACKAGES}

echo "Installing Cargo packages"
cargo install ${CARGO_PACKAGES}

echo "Installing oh-my-zsh"
git clone https://github.com/robbyrussell/oh-my-zsh ${DISTRO_HOME}/.oh-my-zsh

if [[ -d /frb ]]; then
  echo "Creating borg cronjob"
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

ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc

for dir in "${CREATE_DIRS}";
do
  if [[ ! -d ${dir} ]]; then
    echo "Creating directory ${dir}"
    mkdir -p ${dir}
  fi
done

