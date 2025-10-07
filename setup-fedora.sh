#!/bin/bash

# NOTE: Run this script with: sudo bash setup.sh

# 0. Get the invoking username (not root)
USERNAME=${SUDO_USER:-$(whoami)}

# 1. Ensure user is in wheel group and wheel has NOPASSWD sudo
usermod -aG wheel "$USERNAME"
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel-nopasswd
chmod 440 /etc/sudoers.d/wheel-nopasswd

# 2. Define packages to install
DNF_PACKAGES=(
  curl
  ffmpeg
  findutils
  firefox
  flatpak
  flatseal
  git
  gnome-shell-extension-blur-my-shell
  gnome-shell-extension-dash-to-dock
  gnome-shell-extension-gsconnect 
  gnome-shell-extension-just-perfection
  gnome-shell-extension-user-theme
  gnome-tweaks
  go-task
  grep
  gron
  gzip
  hadolint
  htop
  httpie
  iftop
  jq
  less
  make
  mpv
  ncurses
  openssh
  podlet
  podman
  podman-compose
  podman-remote
  ripgrep
  rsync
  shadow-utils
  snapper
  sqlite
  tlp
  tree
  unzip
  vim
  watch
  wget
  whois
  yq
  zathura
  zathura-pdf-mupdf
  zsh
  zsh-syntax-highlighting
)

FLATPAK_PACKAGES=(
  com.getmailspring.Mailspring
  de.haeckerfelix.Shortwave
  io.github.flattool.Warehouse
  io.podman_desktop.PodmanDesktop
  org.cryptomator.Cryptomator
  org.gnome.Evolution
  org.gnome.Extensions
  org.localsend.localsend_app
  org.signal.Signal
  org.telegram.desktop
)

# 3. Update system and install packages
if command -v dnf5 &>/dev/null; then
  dnf5 -y update
  dnf5 -y install --allowerasing "${DNF_PACKAGES[@]}"
else
  dnf -y update
  dnf -y install --allowerasing "${DNF_PACKAGES[@]}"
fi

# 4. Check and install nonfree repositories if missing
REQUIRED_REPOS=(
  fedora-cisco-openh264
  rpmfusion-free
  rpmfusion-nonfree
  rpmfusion-nonfree-nvidia-driver
)

for repo in "${REQUIRED_REPOS[@]}"; do
  if ! dnf repolist | grep -q "$repo"; then
    echo "Installing missing repo: $repo"
    case "$repo" in
      fedora-cisco-openh264)
        dnf -y install fedora-cisco-openh264
        ;;
      rpmfusion-free)
        dnf -y install \
          https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
        ;;
      rpmfusion-nonfree)
        dnf -y install \
          https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        ;;
      rpmfusion-nonfree-nvidia-driver)
        dnf -y install rpmfusion-nonfree-nvidia-driver
        ;;
    esac
  else
    echo "Repo already enabled: $repo"
  fi
done

# 5. Swap ffmpeg-free for full ffmpeg from RPM Fusion
if rpm -q ffmpeg-free &>/dev/null; then
  dnf -y swap ffmpeg-free ffmpeg --allowerasing
fi

# 6. Install multimedia and sound/video packages manually
MULTIMEDIA_PACKAGES=(
  gstreamer1-plugins-base
  gstreamer1-plugins-good
  gstreamer1-plugins-bad-free
  gstreamer1-plugins-bad-freeworld
  gstreamer1-plugins-ugly
  gstreamer1-libav
  lame
  libdvdnav
  libdvdread
  x264
  x265
)

if command -v dnf5 &>/dev/null; then
  dnf5 -y install --allowerasing "${MULTIMEDIA_PACKAGES[@]}"
else
  dnf -y install --allowerasing "${MULTIMEDIA_PACKAGES[@]}"
fi

# 7. Create empty SSH key files with correct permissions
SSH_DIR="/home/$USERNAME/.ssh"
mkdir -p "$SSH_DIR"
touch "$SSH_DIR/id_rsa" "$SSH_DIR/id_rsa.pub"
chmod 600 "$SSH_DIR/id_rsa"
chmod 644 "$SSH_DIR/id_rsa.pub"
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

# 8. Install GNOME Extensions app via Flatpak (user scope)
sudo -u "$USERNAME" flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u "$USERNAME" flatpak install -y flathub "${FLATPAK_PACKAGES[@]}" 

# 9. Change shell to zsh if available and not already set
if [ -x /usr/bin/zsh ]; then
  CURRENT_SHELL=$(getent passwd "$USERNAME" | cut -d: -f7)
  if [ "$CURRENT_SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh "$USERNAME" || echo "Shell change failed."
  fi
  touch "/home/$USERNAME/.zshrc"
  chown "$USERNAME:$USERNAME" "/home/$USERNAME/.zshrc"
else
  echo "Warning: /usr/bin/zsh not found. Shell not changed."
fi

# Setup firewalld
# firewall-cmd --zone=public --add-service=kdeconnect --permanent
firewall-cmd --zone=public --add-port=53317/tcp --permanent  # LocalSend
firewall-cmd --reload

