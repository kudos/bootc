#!/bin/env sh

set -e

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf remove -y \
    ptyxis \
    htop \
    gnome-classic-session \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list \
    open-vm-tools \
    open-vm-tools-desktop \
    qemu-guest-agent \
    spice-vdagent \
    spice-webdavd \
    virtualbox-guest-additions

dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf swap -y libavcodec-free libavcodec-freeworld --allowerasing
dnf remove -y pipewire-libs-extra
# rpmfusion doesn't always have their media packages in sync with Fedora
dnf config-manager setopt rpmfusion-nonfree-updates-testing.enabled=1 rpmfusion-free-updates-testing.enabled=1
dnf group install -y multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin --allowerasing
dnf config-manager setopt rpmfusion-nonfree-updates-testing.enabled=0 rpmfusion-free-updates-testing.enabled=0
dnf config-manager setopt fedora-cisco-openh264.enabled=1
dnf install steam -y
dnf copr enable -y alternateved/eza
dnf copr enable -y alternateved/ghostty
dnf copr enable -y atim/starship
dnf config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/Fedora_Rawhide/shells:zsh-users:zsh-autosuggestions.repo
# Import the GPG key first
rpm --import https://rpm.releases.hashicorp.com/gpg
dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
# No packages for 43 yet, but they're probably still compatible
sed -i 's/\$releasever/42/g' /etc/yum.repos.d/hashicorp.repo
dnf install -y \
    acpi \
    btop \
    direnv \
    dmidecode \
    duf \
    eza \
    ffmpegthumbnailer \
    ghostty \
    git \
    gnome-boxes \
    gstreamer1-vaapi \
    helix \
    helm \
    iperf3 \
    kubectl \
    lm_sensors \
    lsd \
    lshw \
    nautilus-python \
    nmcli \
    mpv \
    ncdu \
    nodejs \
    nut \
    pavucontrol \
    podman-compose \
    podman-docker \
    procs \
    python3-pygit2 \
    python3-dbus \
    python3-secretstorage \
    starship \
    sysstat \
    tailscale \
    terraform \
    uv \
    vdpauinfo \
    vulkan-tools \
    wol \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

dnf clean all

# Remove btop and nvtop shortcuts
rm /usr/share/applications/btop.desktop /usr/share/applications/nvtop.desktop
