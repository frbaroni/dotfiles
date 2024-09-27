#!/bin/bash
set -e # stop if any error

USER_NAME=${USER}
USER_GROUP=${GID}
DISTRO_HOME=$(realpath ~)
FRB_HOME="/frb"
DOTFILES=$(realpath .)
DISTRO=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
VARIANT=$(awk -F= '/^VARIANT=/{print $2}' /etc/os-release | tr -d '"')

SHARED_PACKAGES='git xclip tmux cargo awesome kitty arandr i3lock peek gamemode zsh variety mpc zenity fzf pavucontrol htop xfce4* flatpak ripgrep steam cmake make'
ARCH_PACKAGES='virt-manager qemu cronie nodejs borg'
DEBIAN_PACKAGES='python3-pip'
FEDORA_PACKAGES='python3-pip cronie-anacron npm nodejs network-manager-applet picom xkill syncthing borgbackup lxpolkit podman-docker podman-compose vivaldi-stable gnome-font-viewer'
FLATPAK_PACKAGES='com.discordapp.Discord org.godotengine.Godot org.keepassxc.KeePassXC me.kozec.syncthingtk org.speedcrunch.SpeedCrunch org.flameshot.Flameshot com.uploadedlobster.peek md.obsidian.Obsidian'
CREATE_DIRS="${DISTRO_HOME}/.vim_undo ${DISTRO_HOME}/.vim_backup ${DISTRO_HOME}/.vim_swap"

sudo echo Installing

function ensure_symlink() {
  echo Symlinking $1 to $2
  sudo rm -rf ${2}
  sudo ln -s ${1} ${2}
  sudo chown ${USER_NAME}:${USER_GROUP} ${2}
}

if [ "$DISTRO" = "Debian GNU/Linux" ]; then
  echo "Updating Debiann"
  sudo apt update && sudo apt upgrade -y
  echo "Installing Packages"
  sudo apt install -y ${SHARED_PACKAGES} ${DEBIAN_PACKAGES}
elif [ "$DISTRO" = "Ubuntu" ]; then
  echo "Updating Ubuntu"
  sudo apt update && sudo apt upgrade -y
  echo "Installing Packages"
  sudo apt install -y ${SHARED_PACKAGES} ${DEBIAN_PACKAGES}
  # NEOVIM
  sudo apt install -y ninja-build gettext libtool autoconf automake cmake g++ pkg-config unzip
elif [[ "$DISTRO" = "Fedora Linux" || "$DISTRO" == "Nobara Linux" ]]; then
  if [ "$VARIANT" = "Silverblue" ]; then
    echo "Updating Fedora Silverblue"
    curl -s https://repo.vivaldi.com/archive/vivaldi-fedora.repo | sudo tee /etc/yum.repos.d/vivaldi.repo >/dev/null
    sudo rpm-ostree upgrade
    sudo rpm-ostree install -y --allow-inactive --idempotent ${SHARED_PACKAGES} ${FEDORA_PACKAGES}
    sudo rpm-ostree apply-live --allow-replacement
  else
    echo "Updating Fedora Workstation"
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo

    sudo dnf update && sudo dnf upgrade
    sudo dnf install -y ${SHARED_PACKAGES} ${FEDORA_PACKAGES}

    echo "Install vivaldi"
    sudo dnf install vivaldi-stable
  fi
else
  echo "NOT KNOWN DISTRO :: $DISTRO ::"
fi

echo "Installing Flathub and packages"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub ${FLATPAK_PACKAGES}

echo "Installing Cargo packages"

if [[ -d ${FRB_HOME} ]]; then
  echo "Creating borg cronjob"
  crontab -l | grep -ve "borgbackup\|bt3" | {
    cat;
    echo "@reboot ${FRB_HOME}/Sync/borgbackup/cron.sh";
    echo "26 */4 * * * ${FRB_HOME}/p/bt3/server/cron.sh";
  } | crontab -
  echo "Creating links on /frb"
  ensure_symlink ${FRB_HOME}/VMNetwork ${DISTRO_HOME}/VMNetwork
  ensure_symlink ${FRB_HOME}/Fotos ${DISTRO_HOME}/Fotos
  ensure_symlink ${FRB_HOME}/Fotos ${DISTRO_HOME}/Camera
  ensure_symlink ${FRB_HOME}/KeePass ${DISTRO_HOME}/Keepass
  ensure_symlink ${FRB_HOME}/Sync ${DISTRO_HOME}/Sync
  ensure_symlink ${FRB_HOME}/p ${DISTRO_HOME}/p
fi
echo "Creating links from ${DOTFILES}"
ensure_symlink ${DOTFILES}/ssh ${DISTRO_HOME}/.ssh
ensure_symlink ${DOTFILES}/awesome ${DISTRO_HOME}/.config/awesome
ensure_symlink ${DOTFILES}/vim ${DISTRO_HOME}/.config/nvim
ensure_symlink ${DOTFILES}/vim ${DISTRO_HOME}/.vim
ensure_symlink ${DOTFILES}/kitty ${DISTRO_HOME}/.config/kitty
ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc
mkdir -p ~/.config/variety
ensure_symlink ${DOTFILES}/variety/Favorites ${DISTRO_HOME}/.config/variety/Favorites
ensure_symlink ${DOTFILES}/zsh/zshrc ${DISTRO_HOME}/.zshrc
ensure_symlink ${DOTFILES}/ ${DISTRO_HOME}/dotfiles

for dir in "${CREATE_DIRS}";
do
  if [[ ! -d ${dir} ]]; then
    echo "Creating directory ${dir}"
    mkdir -p ${dir}
  fi
done

# NerdFont
sudo cp ${DOTFILES}/nerdfont/*.ttf /usr/share/fonts
sudo fc-cache -f -v

{ # ActivityWatch runs at http://127.0.0.1:5600
  VERSION=v0.12.2
  cd ~
  wget https://github.com/ActivityWatch/activitywatch/releases/download/${VERSION}/activitywatch-${VERSION}-linux-x86_64.zip
  unzip ./activitywatch-${VERSION}-linux-x86_64.zip
  rm ./activitywatch-${VERSION}-linux-x86_64.zip
}

# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
